resource "aws_eip" "vyos_instance" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.vyos_instance.id}"
  allocation_id = "${aws_eip.vyos_instance.id}"
}

resource "aws_instance" "vyos_instance" {
  ami                    = "${var.ami_vyos}"
  instance_type          = "${var.vyos_instance_type}"
  subnet_id              = "${var.transit_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.vyos_instance.id}"]
  key_name               = "${aws_key_pair.mth_kp.id}"

  tags {
    Name        = "vyos_instance"
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "vyos_instance" {
  name        = "vyos-instance-ssh-sg"
  description = "Allow ssh traffic from certain IP range to vyos_instance on port 22"
  vpc_id      = "${var.transit_vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
