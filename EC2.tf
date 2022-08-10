######################    LOAD_BALANCER     ############################

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
resource "aws_lb_target_group" "tg_terraform" {
  name     = "terraform-tg"
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
    target_group_arn = aws_lb_target_group.tg_terraform.arn
  }
}


################################## EC2         ###########################
resource "aws_instance" "myInstance" {
  ami           = "ami-0ecb2a61303230c9d"
  instance_type = "t2.micro"
  key_name = "assign"
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
