source ./commonvalues.sh  #we need to mention source and ./other script file
Check_Root
dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enabling nodejs 20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "installing nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
   useradd expense &>>$LOGFILE
   VALIDATE $? "creating expense user"
else
   echo -e "Expense user already created $Y Skipping $N"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "downloading code file"

cd /app
rm -rf /app/*  #if second time you run this entire script first weneed to delete exiting data in app directory we use * for that
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "extracted bacend code"

npm install &>>$LOGFILE
VALIDATE $? "installing node js dependencies"

#check your repo and path
#we are giving the absalute patch of backend service to avoid erros
cp /home/ec2-user/calling-other-shell-script/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "copied backend service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "starting backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "installing MYSQL client"

mysql -h 3.86.153.191 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema loading"
#insted of giving public ip we can use dns names first you need to create dns records in AWS to use dns name

systemctl restart backend &>>$LOGFILE
VALIDATE $? "backend service restarting"



