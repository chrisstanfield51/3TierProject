resource "aws_db_subnet_group" "db-subnet" {
  name       = "databasegroup"
  subnet_ids = [aws_subnet.Back-A.id,aws_subnet.Back-B.id]

}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet.id
  vpc_security_group_ids = [aws_security_group.back_security_group.id]
}