variable "aws_region" {
  default = "us-west-2"
}
variable "aws_profile" {
  default = "subaccount"
}
variable "environment" {
  default = "dev"
}

#Ubuntu 16.04 hvm ebs
variable "ami_ubuntu" {
  type = "map"
  default = {
    "us-west-2" = "ami-51537029"
    "eu-west-1" = "ami-c1167eb8"
    "ap-southeast-1" = "ami-a55c1dd9"
  }
}

variable "ami_vyos" {
}

variable "vyos_instance_type" {
  default = "c5.large"
}

variable "key_pair_public_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "key_pair_private_path" {
  default = "~/.ssh/id_rsa"
}

variable "vyos_user" {
  default = "vyos"
}

variable "transit_vpc_id" {
  default = "vpc-0d340491244c06d1a"
}

variable "transit_subnet_id" {
  default = "subnet-0db16f6133bda5b0c"
}
