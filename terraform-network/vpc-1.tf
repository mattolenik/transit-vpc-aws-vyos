module "vpc_1" {
  source = "git@github.com:mattolenik/terraform-aws-vpc.git"

  name = "mth-transit-vpc-1"
  cidr = "172.32.0.0/16"

  azs = ["${var.aws_region}a", "${var.aws_region}b"]

  public_subnets  = ["172.32.1.0/24"]
  private_subnets = ["172.32.2.0/24", "172.32.3.0/24"]

  enable_nat_gateway   = false
  enable_vpn_gateway   = true
  amazon_side_asn      = "65051"
  enable_dns_hostnames = true

  propagate_private_route_tables_vgw = true
  propagate_public_route_tables_vgw  = false

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

resource "aws_vpn_connection" "vpc_1_main" {
  vpn_gateway_id      = "${module.vpc_1.vgw_id}"
  customer_gateway_id = "${aws_customer_gateway.vpc_transit_cgw.id}"
  type                = "ipsec.1"

  #static_routes_only  = true
}

# Generate the VPN Configuration
resource "null_resource" "vpc_1_generate_configuration" {
  triggers {
    configuration = "${aws_vpn_connection.vpc_1_main.customer_gateway_configuration}"
    "test"        = "test"
  }

  provisioner "local-exec" {
    command = "echo '${aws_vpn_connection.vpc_1_main.customer_gateway_configuration}' > vpc-1-vpn-config.vpn.xml"
  }

  provisioner "local-exec" {
    command = "python ../tools/transform-vpn-xml-to-vyatta.py vpc-1-vpn-config.vpn.xml ../tools/vyatta.xsl > vpc-1-vpn-config.vyatta"
  }

  provisioner "local-exec" {
    command = "python ../tools/vyos_config.py vpc-1-vpn-config.vyatta ${aws_instance.vyos_instance.private_ip} ${module.vpc_1.vpc_cidr_block} ${cidrhost(module.vpc_1.vpc_cidr_block, 1)} > ../vpn-generated-configurations/vpc-1-vpn-config.vyos"
  }

  provisioner "local-exec" {
    command = "rm vpc-1-vpn-config.vpn.xml && rm vpc-1-vpn-config.vyatta"
  }
}
