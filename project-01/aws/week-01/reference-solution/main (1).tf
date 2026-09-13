resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

locals {
  subnets = {
    app_a  = { cidr = "10.0.1.0/24", az = "us-east-1a", public = true }
    app_b  = { cidr = "10.0.2.0/24", az = "us-east-1b", public = true }
    data_a = { cidr = "10.0.11.0/24", az = "us-east-1a", public = false }
    data_b = { cidr = "10.0.12.0/24", az = "us-east-1b", public = false }
    mgmt_a = { cidr = "10.0.21.0/24", az = "us-east-1a", public = false }
    mgmt_b = { cidr = "10.0.22.0/24", az = "us-east-1b", public = false }
  }
}

resource "aws_subnet" "subnet" {
  for_each                = local.subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

resource "aws_route_table_association" "assoc" {
  for_each       = local.subnets
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = each.value.public ? aws_route_table.public.id : aws_route_table.private.id
}

resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Web traffic to the app tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

resource "aws_security_group" "data" {
  name = "${var.project_name}-data-sg"
  description = "Allow traffic from the app tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow traffic from the app tier"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-data-sg"
  }
}