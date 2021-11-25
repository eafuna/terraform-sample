data "aws_availability_zones" "available" {
  state = "available"
}

data "template_file" "startup" {
  template = file("init.sh")
}

# NOTE: for debuging purposes only
resource "aws_key_pair" "personal" {
  key_name   = "id_rsa"
  public_key = file("/home/natut/.ssh/id_rsa.pub")
}

resource "aws_security_group" "web-sg" {
  name = "basic_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "ec2" {
  count                  = 2
  ami                    = "ami-036d0684fc96830ca"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = aws_key_pair.personal.key_name
  availability_zone      = data.aws_availability_zones.available.names[count.index]
  user_data              = data.template_file.startup.rendered
  # vpc_security_group_ids = [aws_security_group.web-sg.id]
  # subnet_id              = var.subnet_ids[count.index]

  tags = {
    Name  = "Flugel"
    Owner = "InfraTeam"
  }
}

output "tags_all" {
  value = aws_instance.ec2.*.tags_all
}

output "instance_ids" {
  value = aws_instance.ec2.*.id

}
output "temp_public_ip" {
  value = aws_instance.ec2.*.public_ip
}
