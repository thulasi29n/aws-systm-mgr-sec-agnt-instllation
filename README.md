# aws-onprimesis-cloud-migration
Problem-Statement:
 Migration of a Workload running in a Corporate Data Center to AWS using the Amazon EC2 and RDS service.
 
 High-level Solution:
 The application and database were migrated to AWS using the Lift & Shift (rehost) model, moving both application and database data.
######################################################################################
Flow of Steps:

1. Planning
2. Implementation
3. Go-Live
4. Post Go -live

![flow](https://user-images.githubusercontent.com/26733874/190845806-fc7fcfab-5c41-49fb-bb2a-0892b4977742.png)

##########################################################################################
High Level Architecture
![onpremises-migration-aws_abccompany-arch](https://user-images.githubusercontent.com/26733874/190845850-973e4fdf-8bd5-4ae6-ad9f-7c30cbde4999.png)
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
