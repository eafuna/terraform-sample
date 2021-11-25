terraform {
  required_version = ">=1.0.00"
}

# data "github_actions_public_key" "example_public_key" {
#   repository = "example_repository"
# }

resource "aws_s3_bucket" "flugel_s3" {
  bucket = "flugel-s3-bucket-eafuna-test"
  acl    = "private"

  versioning {
    enabled = true
  }
  tags = {
    Name  = "Flugel"
    Owner = "InfraTeam"
  }
}

resource "aws_instance" "flugel_ec2" {
  ami           = "ami-036d0684fc96830ca"
  instance_type = "t2.micro"

  tags = {
    Name  = "Flugel"
    Owner = "InfraTeam"
  }
}

output "aws_ec2_tag_name" {
  value = aws_instance.flugel_ec2.tags.Name
}
output "aws_ec2_tag_owner" {
  value = aws_instance.flugel_ec2.tags.Owner
}
output "aws_s3_tag_name" {
  value = aws_s3_bucket.flugel_s3.tags.Name
}
output "aws_s3_tag_owner" {
  value = aws_s3_bucket.flugel_s3.tags.Owner
}
