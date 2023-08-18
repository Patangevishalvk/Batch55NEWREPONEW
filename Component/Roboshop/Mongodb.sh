#!bin/bash
set -e 

USER_ID=$(id -u)
COMPONENT=mongodb
LOGFILE="/tmp/${COMPONENT}.log"

if [ $USER_ID -ne 0 ] ; then 
   echo -e "\e[33m Script is expected to executed by the root user \e[0m \n \t Example: \n\t\t sudo bash Wrapper1.sh Frontend"
   exit 1
fi

stat () {
    
    if [ $? -eq 0 ]; then
   echo -e "\e[32m Success \e[0m"
else 
   echo -e "\e[31m Failure \e[0m"    
   exit 2 
    fi
}

echo -n "Configuring ${COMPONENT} repos :"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n "Installing ${COMPONENT} repos :"
yum install -y mongodb-org  &>> ${LOGFILE}
stat $?

echo -n "enablling the ${COMPONENT} visibility :"
sed -ie 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
stat $?

echo -n "Starting the ${COMPONENT} :"
systemctl restart mongod   &>> ${LOGFILE}
stat $?

echo -n "Downloading the ${COMPONENT} schema: "
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip" 
stat $? 

echo -n "Extracing the ${COMPONENT} Schema  :"
cd /tmp 
unzip -o ${COMPONENT}.zip        &>> ${LOGFILE} 
stat $? 

echo -n "Injecting ${COMPONENT} Schema : "
ls -ltr
cd ${COMPONENT}-main
mongo < catalogue.js    &>>  ${LOGFILE}
mongo < users.js        &>>  ${LOGFILE}
stat $? 


