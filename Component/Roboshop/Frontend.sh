#!bin/bash

set -e 

USER_ID=$(id -u)
Component=Frontend
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
echo -e "Configuring ${COMPONENT}"
echo -n "Installing NGINIX :"
yum install nginx -y &>>  ${LOGFILE}
stat $?

echo -n "enablling and starting the nginx :"
systemctl enable nginx   &>>  ${LOGFILE}
systemctl start nginx    &>>  ${LOGFILE}
stat $?

echo -n "Downloading the ${COMPONENT} :"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip" &>>  ${LOGFILE}
stat $?

echo -n "Cleaning the ${COMPONENT} :"
cd /usr/share/nginx/html &>>  ${LOGFILE}
rm -rf *
stat $?

echo -n "Extracting ${COMPONENT} :"
unzip /tmp/Frontend.zip     &>>  ${LOGFILE}
stat $?

echo -n "Sorting the ${COMPONENT} files :"
mv ${COMPONENT}-main/* . 
mv static/* . 
rm -rf ${COMPONENT} README.md 
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Restarting ${COMPONENT} :"
systemctl daemon-reload &>>  ${LOGFILE}  
systemctl restart nginx &>>  ${LOGFILE}
stat $?


