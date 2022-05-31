#Security group for the bastion in the public subnet.  
resource "aws_security_group" "bastion_security_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound to anywhere"
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#security group for EC2 in middle subnet
resource "aws_security_group" "middle_security_group" {
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from Front Subnet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_subnet.Front.cidr_block]

  }

  ingress {
    description      = "MySQL port from Back Subnet"
    from_port        = 3309
    to_port          = 3309
    protocol         = "tcp"
    cidr_blocks      = [aws_subnet.Back-A.cidr_block,aws_subnet.Back-B.cidr_block]

  }

  egress {
      description      = "Outbound to anywhere"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]

    }
}

#security group for RDS in Back subnet
resource "aws_security_group" "back_security_group" {
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "MySQL from Middle Subnet"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [aws_subnet.Middle-A.cidr_block,aws_subnet.Middle-B.cidr_block]
    
  }


  egress {
    description      = "Outbound to anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}