module "vpc" {

    source = "../modules/vpc"
    name = "agile"
    vpc_cidr_block = "10.0.0.0/24"
    tag_value = "agile vpc"
    subnet_count = 2
    newbits  = 2
    route_table_cidr_block = "0.0.0.0/0"
    route_table_association_count = 2

}

module "ecr" {
    source = "../modules/ecr"
    scan_on_push = true
    repo_name    = "agilemd"

}