# 3-Tier-Project
This is a basic 3 tier architecture with a presentation tier, application tier, data tier, and a repare function.
As of now there is no application as the goal of this project was to achomplish the following:
- (Complete) Create a 3 tier architecture with terraform.  The IaC builds an S3 bucket for Presentation Tier with CloudFront setup, an EC2 autoscaling group with an ELB attached in the Application Tier, and an RDS instance in the Data Tier.  
- (Complete) Deploy these resources in CodePipeline.
- (Complete) Test the IAC with SNYK to ensure security.
- (Complete) Use a custom EC2 image for the autoscaling group.  This is built during the deployment process in CodePipeline using Packer
- Build a reaper function in lambda to delete assets after 24 hours.  This needs to have automated unit testing.
***The function currently works but I'm currently learning how to do local development and unit testing.***


