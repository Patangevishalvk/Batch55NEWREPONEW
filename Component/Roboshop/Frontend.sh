#!bin/bash

set -e 
Component=$1

USER_ID=$(id -u)

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
yum install nginx -y &>>  /tmp/${COMPONENT}.log

stat $?

echo -n "enablling and starting the nginx :"

systemctl enable nginx   &>>  /tmp/${COMPONENT}.log
systemctl start nginx    &>>  /tmp/${COMPONENT}.log

stat $?

echo -n "Downloading the ${COMPONENT} component :"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip" &>>  /tmp/${COMPONENT}.log

stat $?

echo -n "Cleaning the ${COMPONENT} :"

cd /usr/share/nginx/html &>>  /tmp/${COMPONENT}.log
rm -rf *
stat $?

echo -n "Extracting ${COMPONENT} :"
unzip /tmp/${COMPONENT}.zip &>>  /tmp/${COMPONENT}.log
stat $?


echo -n "Sorting ${COMPONENT} :"

mv ${COMPONENT}-main/* . &>>  /tmp/${COMPONENT}.log
mv static/* . &>>  /tmp/${COMPONENT}.log
rm -rf static README.md &>>  /tmp/${COMPONENT}.log
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Re-starting ${COMPONENT} :"
systemctl daemon-reload &>>  /tmp/${COMPONENT}.log  
systemctl restart nginx &>>  /tmp/${COMPONENT}.log
stat $?


