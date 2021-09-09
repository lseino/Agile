output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "private_subnet_arns" {
  value = aws_subnet.private.*.arn
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "public_subnet_arns" {
  value = aws_subnet.public.*.arn
}

output "igw_id" {
  value = aws_internet_gateway.vpc_igw.id
}

output "igw_arn" {
  value = aws_internet_gateway.vpc_igw.arn
}

output "security_group_id" {
  value = aws_security_group.main_sg.id
}