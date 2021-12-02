variable "basic_sg_id" {}

variable "subnet_ids" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# resource "aws_key_pair" "personal" {
#   key_name   = "id_rsa"
#   public_key = file("/home/XXX/.ssh/id_rsa.pub")
# }


data "template_file" "script" {
  template = file("init.py")
}

data "template_file" "cloudinit" {
  template = file("cloud-init.yaml")
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.cloudinit.rendered
  }

  part {
    filename     = "init.py"
    content_type = "text/x-shellscript"
    content      = data.template_file.script.rendered
  }

}

resource "aws_instance" "ec2" {
  count                  = 2 
  ami                    = "ami-036d0684fc96830ca"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids[count.index]
  availability_zone      = data.aws_availability_zones.available.names[count.index]
  user_data              = data.template_cloudinit_config.config.rendered
  vpc_security_group_ids = [var.basic_sg_id]
  # key_name               = aws_key_pair.personal.key_name

  associate_public_ip_address = true

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

output "subnets" {
  value = aws_instance.ec2.*.subnet_id
}
