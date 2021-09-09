resource "aws_subnet" "private" {
    count = var.subnet_count
    vpc_id = aws_vpc.vpc.id
    availability_zone = data.aws_availability_zones.available.names[count.index]
    cidr_block = cidrsubnet(var.vpc_cidr_block, var.newbits, count.index + 2)

    tags = {
        Name = "${var.tag_value}-private-subnet-${count.index}"
    }
}

resource "aws_eip" "nat" {
  count = var.subnet_count
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  count = var.subnet_count
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id = element(aws_subnet.public.*.id, count.index)
}

resource "aws_route_table" "private" {
  count = var.subnet_count
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.route_table_cidr_block
    nat_gateway_id  = element(aws_nat_gateway.gw.*.id, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count= var.route_table_association_count
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}