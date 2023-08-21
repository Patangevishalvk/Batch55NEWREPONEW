#!bin/bash
set -e 

USER_ID=$(id -u)
COMPONENT=Catalog
LOGFILE="/tmp/${COMPONENT}.log"
APPUSER="roboshop"

if [ $USER_ID -ne 0 ] ; then 
   echo -e "\e[33m Script is expected to executed by the root user \e[0m \n \t Example: \n\t\t sudo bash Wrapper1.sh Catalog"
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
curl --silent --location https://rpm.nodesource.com/setup_16.x | bash - &>> ${LOGFILE}
stat $?

echo -n "Installing Nodejs repos :"
yum install nodejs -y &>> ${LOGFILE}
stat $?

id ${APPUSER} &>> ${LOGFILE}
if  [ $? -ne 0 ] ; then 
echo -n "Creating Application User Account :"
useradd roboshop
fi 
stat $?

echo -n "Downloading the ${COMPONENT} :"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $?

echo -n "Copying the ${COMPONENT} to ${APPUSER} home directory"
cd /home/${APPUSER}/
rm -rf ${COMPONENT}             &>> ${LOGFILE}
unzip -o /tmp/${COMPONENT}.zip  &>> ${LOGFILE}
stat $?

echo -n "Changing the Ownership :"
mv ${COMPONENT} -main ${COMPONENT}
chown -R ${APPUSER}:${APPUSER} /home/${APPUSER}/${COMPONENT}/
stat $?

echo -n "Generating the ${COMPONENT} artifacts :"
cd /home/${APPUSER}/${COMPONENT} &>> ${LOGFILE}
npm install &>> ${LOGFILE}
stat $?


# echo -n "Downloading the ${COMPONENT} schema: "
# curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip" 
# stat $? 

# echo -n "Extracing the ${COMPONENT} Schema  :"
# cd /tmp 
# unzip -o ${COMPONENT}.zip        &>> ${LOGFILE} 
# stat $? 

# echo -n "Injecting ${COMPONENT} Schema : "
# cd ${COMPONENT}-main
# mongo < catalogue.js    &>>  ${LOGFILE}
# mongo < users.js        &>>  ${LOGFILE}
# stat $? 

# echo -e "\e[35m ${COMPONENT} Installation Is Completed \e[0m \n"
