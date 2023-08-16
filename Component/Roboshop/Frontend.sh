#!bin/bash

echo " I am Frontend User"

1. 

# yum install nginx -y
# systemctl enable nginx
# systemctl start nginx

2. 
# curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

3. 

# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf

USER_ID =$(id -u)

if [ $USER_ID -ne 0 ] ; then 
echo -e "\e[32m Script is expected to executed by the root user \e[0m \n \t ]"

exit 1

fi

echo " COnfiguring Frontend"

yum install nginx -y




