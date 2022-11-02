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

Hands On Project - Part 1 - Terraform

- Download VSCode and install the Terraform extension:
https://code.visualstudio.com/download

- Download and unzip Terraform files (available in the project files)

- Edit Terraform main.tf file using the VSCode:
-- Change the VPC_ID and SUBNET_ID according to your default VPC

- Create SSH Key Pair
-- name: sshkey1
-- format: .pem

- Install Terraform on AWS Cloud Shell

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

- Upload your edited terraform code to AWS Cloud Shell and unzip it

- Run terraform

$ terraform init
$ terraform plan
$ terraform apply

- Explore more about Terraform on https://learn.hashicorp.com/terraform

Hands On Project - Part 2 - AWS Systems Manager

- Create an IAM role SystemsManagerToSNS

Policy: AmazonSNSFullAccess

- Create a Notification Topic DevOpsNotification | Copy the ARN

- Create a subscription - email:

- Run the System Manager Quick Setup
-- Targets: choose instances manually

- Validate the 'configuration':  "Success" status

- Explore the Session Manager connecting by SSH browser (please note: if the EC2 instances don't show up, reboot both instances using the EC2 console to re-run the SSM-agent startup script)

- Execute "Run Command" to deploy the "security agent instalation"

-- Command document: AWS-RunShellScript

-- Command parameters:

sudo wget -q <<upload install_security_agent.sh  to S3 (available in project)and provide the link >> -P /tmp
sudo chmod +x /tmp/install_security_agent.sh
sudo /tmp/install_security_agent.sh
ls -ltr /usr/bin/security_agent

-- Targets: choose instances manually

-- Uncheck enable writing to S3 Bucket.

-- Enable SNS Notification

IAM Role: SystemsManagertoSNS
SNS Topic: <ARN>

Events notifications:  all Events

Change notifications

Notify me for: Per instance basis

- Open the AWS Cloud Shell and remove the resources created by Terraform

(If needed, re-install the Terraform following the same steps used previously)

cd terraform
./terraform destroy

That's All! Congrats, Bootcamper!

Supporting Links:

https://aws.amazon.com/premiumsupport/knowledge-center/systems-manager-ec2-instance-not-appear/
        
Once you done validating -- go ahead and destroy all the resources.      
