variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {}

variable "cidr_block" {
  type = string

  # /25 = 128 hosts
  # NOTE: that some of this will be reserved by aws?
  # REFERENCE: https://www.ipaddressguide.com/cidr

  # NOTE:Our requirement will be one subnet for the entire vpc
  default = "10.0.0.0/25"
}
