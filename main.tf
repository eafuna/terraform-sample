terraform {
  required_version = ">=1.0.11"
}

module "ec2_instance" {
  source = "./ec2"
  # subnet_ids = module.network.subnet_ids
}

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

output "aws_ec2_tags_all" {
  value = module.ec2_instance.tags_all
}
output "aws_ec2_publicips_all" {
  value = module.ec2_instance.temp_public_ip
}
# output "aws_s3_tag_name" {
#   value = aws_s3_bucket.flugel_s3.tags.Name
# }
# output "aws_s3_tag_owner" {
#   value = aws_s3_bucket.flugel_s3.tags.Owner
# }
