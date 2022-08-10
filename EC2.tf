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
