terraform {
  required_version = ">=1.0.11"
}

module "network" {
  source        = "./network"
  cidr_block    = var.cidr_block
  ec2_instances = module.ec2_instance.instance_ids
}

module "ec2_instance" {
  source      = "./ec2"
  basic_sg_id = module.network.basic_sg_id
  subnet_ids  = module.network.subnet_ids
}

#-----------------------------------------------
# TODO: restore aws_s3_bucket
#-----------------------------------------------
# resource "aws_s3_bucket" "flugel_s3" {
#   bucket = "flugel-s3-bucket-eafuna-test"
#   acl    = "private"

#   versioning {
#     enabled = true
#   }
#   tags = {
#     Name  = "Flugel"
#     Owner = "InfraTeam"
#   }
# }

# ec2 module
# output "aws_ec2_tags_all" {
#   value = module.ec2_instance.tags_all
# }
output "aws_ec2_subnets" {
  value = module.ec2_instance.subnets
}
output "aws_ec2_instances_all" {
  value = module.ec2_instance.instance_ids
}
output "aws_ec2_publicips_all" {
  value = module.ec2_instance.temp_public_ip
}
# network module 
output "aws_alb_dns_name" {
  value = module.network.alb_dns_name
}
output "aws_alb_subnet" {
  value = module.network.subnet_ids
}

# output "aws_s3_tags_all" {
#   value = aws_s3_bucket.flugel_s3.tags_all
# }
