variable "basic_sg_id" {}

variable "subnet_ids" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "template_file" "startup" {
  template = file("init.sh")
}

data "template_file" "pyfile" {
  template = file("init.py")
}

resource "aws_key_pair" "personal" {
  key_name   = "id_rsa"
  public_key = file("/home/natut/.ssh/id_rsa.pub")
}

resource "aws_instance" "ec2" {
  count                  = 2
  ami                    = "ami-036d0684fc96830ca"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids[count.index]
  availability_zone      = data.aws_availability_zones.available.names[count.index]
  key_name               = aws_key_pair.personal.key_name
  user_data              = data.cloudinit_config.main.rendered
  vpc_security_group_ids = [var.basic_sg_id]

  #--------------------------------------------------
  # TODO: 
  # removing this will remove egress of the instance which would in turn 
  # prevent us from installing nginx as required
  #--------------------------------------------------
  associate_public_ip_address = true

  tags = {
    Name  = "Flugel"
    Owner = "InfraTeam"
  }
}

data "cloudinit_config" "main" {
  gzip          = false
  base64_encode = false

  # --------------------------------------------------
  # TODO: run python script
  # --------------------------------------------------
  # part {
  #   content_type = "text/x-shellscript"
  #   filename     = "init.py"
  #   content      = data.template_file.pyfile.rendered
  # }

  part {
    content_type = "text/x-shellscript"
    filename     = "init.sh"
    content      = data.template_file.startup.rendered
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

output "subnets" {
  value = aws_instance.ec2.*.subnet_id
}
