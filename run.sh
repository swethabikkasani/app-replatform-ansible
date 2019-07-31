#! /bin/bash

cd /var/lib/jenkins/app-replatform-ansible/

DB_HOST="$(cat /var/lib/jenkins/app-replatform-tfscripts/configuration/rds/terraform.tfstate| jq '.modules[0].outputs.db_instance_address.value' | xargs)"
sed -i "s/DB_HOST:.*/DB_HOST:/" /var/lib/jenkins/app-replatform-ansible/tomcat-servers
sed -i "s/DB_HOST:.*/DB_HOST: ${DB_HOST}/" /var/lib/jenkins/app-replatform-ansible/tomcat-servers

DB_PASSWORD="$(cat /var/lib/jenkins/app-replatform-tfscripts/configuration/rds/terraform.tfstate| jq '.modules[1].outputs.this_db_instance_password.value' | xargs)"
sed -i "s/DB_PASSWORD:.*/DB_PASSWORD:/" /var/lib/jenkins/app-replatform-ansible/tomcat-servers
sed -i "s/DB_PASSWORD:.*/DB_PASSWORD: ${DB_PASSWORD}/" /var/lib/jenkins/app-replatform-ansible/tomcat-servers

DB_USER="$(cat /var/lib/jenkins/app-replatform-tfscripts/configuration/rds/terraform.tfstate| jq '.modules[1].outputs.this_db_instance_username.value' | xargs)"
sed -i "s/DB_USER:.*/DB_USER:/" /var/lib/jenkins/app-replatform-ansible/tomcat-servers
sed -i "s/DB_USER:.*/DB_USER: ${DB_USER}/" /var/lib/jenkins/app-replatform-ansible/tomcat-servers

DB_PORT="$(cat /var/lib/jenkins/app-replatform-tfscripts/configuration/rds/terraform.tfstate| jq '.modules[1].outputs.this_db_instance_port.value' | xargs)"
sed -i "s/DB_PORT:.*/DB_PORT:/" /var/lib/jenkins/app-replatform-ansible/tomcat-servers
sed -i "s/DB_PORT:.*/DB_PORT: ${DB_PORT}/" /var/lib/jenkins/app-replatform-ansible/tomcat-servers

DB_NAME="$(cat /var/lib/jenkins/app-replatform-tfscripts/configuration/rds/terraform.tfstate| jq '.modules[1].outputs.this_db_instance_name.value' | xargs)"
sed -i "s/DB_NAME:.*/DB_NAME:/" /var/lib/jenkins/app-replatform-ansible/tomcat-servers
sed -i "s/DB_NAME:.*/DB_NAME: ${DB_NAME}/" /var/lib/jenkins/app-replatform-ansible/tomcat-servers

if ["${DB_PORT}" =~ "3306" ]]; then
  DB_DRIVER = mysql
  DB_DCLASS = "com.mysql.jdbc.Driver"
elif ["${DB_PORT}" =~ "5432" ]]; then
  DB_DRIVER = postgresql
  DB_DCLASS = "org.postgresql.Driver"
elif ["${DB_PORT}" =~ "1433" ]]; then
  DB_DRIVER = sqlserver
  DB_DCLASS = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
elif ["${DB_PORT}" =~ "1521" ]]; then
  DB_DRIVER = oracle
  DB_DCLASS = "oracle.jdbc.driver.OracleDriver"
fi

ansible-playbook -i hosts --private-key ~/.ssh/Jenkins-KP.pem test.yml
