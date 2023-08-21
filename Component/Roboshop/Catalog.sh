USER_ID=$(id -u)
COMPONENT=catalogue
LOGFILE="/tmp/${COMPONENT}.log"
APPUSER="roboshop"

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

echo -n "Configuring ${COMPONENT} repo  :"

curl --silent --location https://rpm.nodesource.com/setup_16.x | bash - &>> ${LOGFILE}
stat $?

echo -n "Installing Nodejs :"
yum install nodejs -y &>> ${LOGFILE}
stat $?

id ${APPUSER} &>> ${LOGFILE}
if  [ $? -ne 0 ] ; then 
echo -n "Creating Application User Account :"
useradd roboshop
stat $?
fi 

echo -n "Downloading the ${COMPONENT} :"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip" &>> ${LOGFILE}
set -e 
stat $?

echo -n "Copying the ${COMPONENT} to ${APPUSER} home directory"
cd /home/${APPUSER}/
rm -rf ${COMPONENT}             &>> ${LOGFILE}
unzip -o /tmp/${COMPONENT}.zip  &>> ${LOGFILE}
stat $?

echo -n "Changing the ownership"
mv ${COMPONENT}-main ${COMPONENT} 
chown -R ${APPUSER}:${APPUSER} /home/${APPUSER}/${COMPONENT}/
stat $?

echo -n "Generating the ${COMPONENT} artifacts :"
cd /home/${APPUSER}/${COMPONENT}/ &>> ${LOGFILE}
npm install &>> ${LOGFILE}
stat $?


echo -n "Configuring the ${COMPONENT} system file :"
sed -ie 's/MONGO_DNSNAME/mongodb.roboshop.internal/' home/${APPUSER}/${COMPONENT}/systemd.service 
mv /home/${APPUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $?

echo -n "Strating the ${COMPONENT} service:"
systemctl daemon-reload &>> ${LOGFILE}
systemctl enable ${COMPONENT} &>> ${LOGFILE}
systemctl restart ${COMPONENT} &>> ${LOGFILE}
systemctl status ${COMPONENT} -l
stat $?

echo -e "\e[35m ${COMPONENT} Installation Is Completed \e[0m \n"





