#!bin/bash
set -e 

USER_ID=$(id -u)
COMPONENT=Mongodb
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
systemctl Start mongod    &>> ${LOGFILE}
stat $?





#echo -e "Configuring ${COMPONENT}"
#echo -n "Installing NGINIX :"
#yum install nginx -y &>>  ${LOGFILE}
#stat $?

#echo -n "enablling and starting the nginx :"
#systemctl enable nginx   &>>  ${LOGFILE}
#systemctl start nginx    &>>  ${LOGFILE}
#stat $?

#echo -n "Downloading the ${COMPONENT} :"
#curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip" &>>  ${LOGFILE}
#stat $?

#echo -n "Cleaning the ${COMPONENT} :"
#cd /usr/share/nginx/html &>>  ${LOGFILE}
#rm -rf *
#stat $?

#echo -n "Extracting ${COMPONENT} :"
#unzip /tmp/Frontend.zip     &>>  ${LOGFILE}
#stat $?

#echo -n "Restarting ${COMPONENT} :"
#systemctl daemon-reload &>>  ${LOGFILE}  
#systemctl restart nginx &>>  ${LOGFILE}
#stat $?


