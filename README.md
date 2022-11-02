# aws-system-manager-SNS-Automation of Security Agent Installation
Project title:
Implementation of a set of EC2 instances using Terraform and AWS Systems Manager configuration with Amazon Simple Notification Service for automated installation of security officers
 
 High-level Solution:
In this project,as a DevSecOps Engineer I deployed a set of EC2 instances and infrastructure in an automated way using Terraform (infrastructure as code - IaC). Also, it was necessary to install a specific security agent on all these instances in an automated way.

Once I provisioned the infrastructure, AWS System Manager and its component Command Run were used to install the security agents in an automated way. I used the Amazon Simple Notification Service – SNS to send an email informing the whole process status.
######################################################################################
Flow of Steps:

1. Planning
2. Implementation
3. Go-Live
4. Post Go -live

![1](https://user-images.githubusercontent.com/26733874/199411863-f4b7166d-dbaf-4950-9523-2ae120a4412d.png)


##########################################################################################
High Level Architecture
![2](https://user-images.githubusercontent.com/26733874/199411899-4f3e1778-552b-4ba6-91fb-7b75dcf1689f.png)

#########################################################################################

Steps:
1. Perform Baseline and Target systems Infra details and document for planning the migration.(please refer attached xlsx)
2. Create a VPC
      2.1) Assign a CIDR block. (It should NOT overlap with on-premises or other cloud providers).
3. Create Subnets and CIDR blocks.
      3.1) public subnet for Internet Traffic.
      3.2) private Subnet for Database.
4. Create an Internet Gateway, Attach it to a VPC.
5. Create an Route -> Add route: 0.0.0.0/0 - Target: Internet Gateway
6. Create a new EC2 instance (details can be found in planning xlsx - FYR)
      6.1) Assign Public IP
7. Create a RDS instance.(details can be found in planning xlsx - FYR)
8. SSH into EC2 instance -- ssh ubuntu@<PUBLIC_IP> -i <ssh_private_key>  || you can open EC2 AWS console
     8.1) Install phyton and mysql client.( This is based on the baseline architecture)
                sudo apt-get update
                sudo apt-get install python3-dev -y
                sudo apt-get install libmysqlclient-dev -y
                sudo apt-get install unzip -y
                sudo apt-get install libpq-dev python-dev libxml2-dev libxslt1-dev  libldap2-dev -y
                sudo apt-get install libsasl2-dev libffi-dev -y

                curl -O https://bootstrap.pypa.io/get-pip.py ; python3 get-pip.py --user

                export PATH=$PATH:/home/ubuntu/.local/bin/

                pip3 install flask
                pip3 install wtforms
                pip3 install flask_mysqldb
                pip3 install passlib

                sudo apt install awscli -y
                sudo apt-get install mysql-client -y
  9. Open RDS Security Group
        9.1) Type : MYSQL
        9.2) Source : 0.0.0.0/0 ( This is not good practice to open connectivity for all IP's)
               --- restrict  source to EC2 - (copy CIDR of EC2 and include in source)
  10. Connect to the EC2 instance -- ssh ubuntu@<PUBLIC_IP> -i <ssh_private_key>
         10.1) Download the dump file and app file  -- you can upload files into S3 and can be downloaded into EC2 instance (files attached for your reference)
         10.2) Use wget <<S3 Address>>
  11. Connect to MySQL running on AWS RDS
         11.1) mysql -h <RDS_ENDPOINT> -P 3306 -u admin -p
         11.2) Create the wiki DB and import data -- create database wikidb; use wikidb;
         11.3) source dump-en.sql;
         11.4) Create the user wiki in the wikidb
                       CREATE USER wiki@'%' IDENTIFIED BY 'wiki123456';
                       GRANT ALL PRIVILEGES ON wikidb.* TO wiki@'%';
                       FLUSH PRIVILEGES;
  12. Unzip the app files -- unzip wikiapp-en.zip -- cd wikiapp
         12.1) Edit the wiki.py file and change the MYSQL_HOST and point to the RDS endpoint
  13. Bring up the application
         13.1) run python3 wiki.py
  14. Steps to validate the migration:
         14.1) Open the AWS console, copy the public IP and test the application using:<EC2_PUBLIC_IP>:8080
         14.2) Login to the application (user:admin / password:) -- same as user
         14.3) Create a new article
        
  15. Once you done validating -- go ahead and destroy all the resources.      
