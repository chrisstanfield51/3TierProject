packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "PKR_VAR_ACCESS_ID" {
  type    = string
}

variable "PKR_VAR_ACCESS_SECRET" {
  type    = string
}

source "amazon-ebs" "image" {
  access_key = ${var.PKR_VAR_ACCESS_ID}
  secret_key = ${var.PKR_VAR_ACCESS_SECRET}
  ami_name         = "Test_EC2_325"
  instance_type    = "t2.micro"
  ssh_username     = "ec2-user"
  region           = "us-west-2"
  source_ami       = "ami-0ca285d4c2cda3300"
  force_deregister = "true"
  run_tags = {
    Name = "Test_EC2"
  }
}

build {
  sources = [
    "source.amazon-ebs.image"
  ]
}