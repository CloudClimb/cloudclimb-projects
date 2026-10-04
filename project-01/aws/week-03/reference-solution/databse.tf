resource "aws_db_subnet_group" "main" {
  name        = "cloudclimb-project01-db-subnet-group"
  description = "Main DB Subnet Group"
  subnet_ids = [
    aws_subnet.subnet["data_a"].id,
    aws_subnet.subnet["data_b"].id
  ]

  tags = {
    Name = "Main DB Subnet Group"
  }

}

resource "aws_db_instance" "main" {
  identifier                  = "cloudclimb-project01-db"
  allocated_storage           = 20
  engine                      = "postgres"
  engine_version              = "16.4"
  instance_class              = "db.t3.micro"
  db_name                     = "memos"
  username                    = "memos"
  db_subnet_group_name        = aws_db_subnet_group.main.name
  vpc_security_group_ids      = [aws_security_group.data.id]
  publicly_accessible         = false
  skip_final_snapshot         = true
  manage_master_user_password = true


  tags = {
    Name = "Main DB Instance"
  }
}
