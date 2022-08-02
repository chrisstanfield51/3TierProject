# 3-Tier-Project

***This project is currently in progress.  Better explanation to come.***

This is a basic 3 tier architecture with a presentation tier, application tier, data tier, and a reaper function.
As of now there is no application to test as the goal of this project was to acchomplish the following:
- (Complete) Create a 3 tier architecture with terraform.  The IaC builds an S3 bucket for Presentation Tier with CloudFront setup, an EC2 autoscaling group with an ELB attached in the Application Tier, and an RDS instance in the Data Tier.  Security groups and IAM roles are added as well.
- (Complete) Deploy these resources utlizing CodePipeline.  
- (Complete) Test the IAC with SNYK to ensure security.
- (Complete) Use a custom EC2 image for the autoscaling group.  This is built during the deployment process in CodePipeline using Packer
- Build a reaper function in lambda to delete assets after 24 hours.  This needs to have automated unit testing.
***The function currently works but I'm currently learning how to do local development and unit testing.***


