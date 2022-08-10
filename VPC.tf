#############################                #VPC            ##################################################                                                              
resource "aws_vpc" "terraform" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_classiclink_dns_support = true

  enable_classiclink = true
  tags ={
    Name = "teraform"
  }
}
###################           SUBNET         ######################################
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.terraform.id           
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    "Name" = "Tarreform"
  }
}
resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.terraform.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    "Name" = "Tarreform"
  }
}
###################         INTERNET GATE WAY    #################################

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform.id
  tags = {
    "Name" = "Terraform"
  }
}

############################  SECURITY GROUP       #####################################
resource "aws_security_group" "allow" {
  name        = "allow"
  vpc_id      = aws_vpc.terraform.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow"
  }
}

###################################### ROUTE TABLE    ############################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
  
  tags = {
    Name = "publicRouteTable"
  }
}

#########################################  ROUTE TABLE ASSOCIATE   ############################

resource "aws_route_table_association" "forPublic" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id =   aws_route_table.public.id

}
