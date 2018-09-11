module "vpc_transit" {
  source = "terraform-aws-modules/vpc/aws"

  name       = "private"
  create_vpc = false
  cidr       = "172.31.0.0/16"

  azs = ["${var.aws_region}a", "${var.aws_region}b"]

  public_subnets  = ["172.31.2.0/24"]
  private_subnets = ["172.31.1.0/24"]

  enable_nat_gateway   = false
  enable_vpn_gateway   = false
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

resource "aws_customer_gateway" "vpc_transit_cgw" {
  bgp_asn    = 65013
  ip_address = "${aws_eip.vyos_instance.public_ip}"
  type       = "ipsec.1"

  tags {
    Name        = "vpc-transit-customer-gateway"
    Environment = "${var.environment}"
    Terraform   = "true"
  }
}

#
#
# resource "aws_route" "route_vpc_1" {
#   count = "${length(aws_instance.vyos_instance.id)}"
#
#   route_table_id            = "${element(module.vpc_transit.public_route_table_ids, count.index)}"
#   destination_cidr_block    = "10.232.0.0/20"
#   instance_id               = "${aws_instance.vyos_instance.id}"
# }
#
# resource "aws_route" "route_vpc_2" {
#   count = "${length(aws_instance.vyos_instance.id)}"
#
#   route_table_id            = "${element(module.vpc_transit.public_route_table_ids, count.index)}"
#   destination_cidr_block    = "10.146.0.0/20"
#   instance_id               = "${aws_instance.vyos_instance.id}"
# }

