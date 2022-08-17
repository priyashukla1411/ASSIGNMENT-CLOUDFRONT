resource "aws_lb" "test" {
  name               = "Terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow.id]
  subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id ]

  enable_deletion_protection = false

  tags = {
    Name = "Terraform"
  }
}
############################### TARGET GROUP   ##############################
resource "aws_lb_target_group" "tg_terraform987" {
  name     = "terraform-tg1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform.id
}



############# lISTNER ########
resource "aws_lb_listener" "LG" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_terraform987.arn
  }
}

################################## EC2         ###########################
resource "aws_instance" "myInstance1" {
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"

  tags                         = {
        "Name" = "instance1"
    }
    user_data = <<-EOF
                  #!/bin/bash
                  sudo apt update -y
                  sudo apt-get install -y apache2
                  sudo systemctl start apache2
                  sudo systemctl enable apache2
                  sudo apt update
                EOF
}


