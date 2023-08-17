#!bin/bash

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
echo -e "Configuring Frontend"

echo -n "Installing Frontend :"
yum install nginx -y &>>  /tmp/frontend.log

stat $?

echo -n "enablling and starting the nginx :"

systemctl enable nginx   &>>  /tmp/frontend.log
systemctl start nginx    &>>  /tmp/frontend.log

stat $?

echo -n "Downloading the Frontend component :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" &>>  /tmp/frontend.log

stat $?

echo -n "Cleaning the Frontend :"

cd /usr/share/nginx/html &>>  /tmp/frontend.log
rm -rf *
stat $?

echo -n "Extracting Frontend :"
unzip /tmp/frontend.zip &>>  /tmp/frontend.log
stat $?


echo -n "Sorting Frontend :"

mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md &>>  /tmp/frontend.log
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Re-starting Frontend :"
systemctl daemon-reload &>>  /tmp/frontend.log  
systemctl restart nginx &>>  /tmp/frontend.log



