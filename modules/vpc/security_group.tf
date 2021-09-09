resource "aws_security_group" "main_sg" {
  name = "vpc-sg"
  description = "vpc communication"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.route_table_cidr_block]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [var.route_table_cidr_block]
  }

  tags = {
    Name = "${var.name}"
  }
}
