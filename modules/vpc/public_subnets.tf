resource "aws_subnet" "public" {
    count = var.subnet_count
    vpc_id = aws_vpc.vpc.id
    availability_zone = data.aws_availability_zones.available.names[count.index]
    cidr_block = cidrsubnet(var.vpc_cidr_block, var.newbits, count.index)
    map_public_ip_on_launch = var.map_public_ip_on_launch

    tags = {
        Name = "${var.tag_value}-public-subnet-${count.index}"
    }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
}

resource "aws_route_table_association" "public" {
  count = var.route_table_association_count
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}