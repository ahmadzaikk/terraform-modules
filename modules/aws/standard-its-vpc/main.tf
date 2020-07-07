# vpc
module "vpc" {
  cidr_block = var.cidr_block
  enabled    = var.enabled
  name       = join("-", [var.name, "vpc"])
  #source = "git::ssh://git@github.com/ucopacme/terraform-module.git//modules/aws/vpc?ref=v0.0.1"
  source = "../vpc?ref=v0.0.1"
  #source = "git::ssh://example.com/vpc.git?ref=v1.2.0"
  tags       = merge(var.tags, map("Name", var.name))
}

# vpc public subnets module
module "vpc_public_subnets" {
  availability_zones = var.azs
  enabled            = var.enabled
  name               = join("-", [var.name, "vpc-public-subnet"])
  new_bits           = "2"
  source = "../vpc_subnets?ref=v0.0.1"
  subnet_cidr        = cidrsubnet(var.cidr_block, var.subnet_tier_bits, var.public_subnet_index)
  tags               = merge(var.tags, map("Name", var.name))
  vpc_id             = module.vpc.vpc_id
}

# vpc tgw subnets module
module "vpc_tgw_subnets" {
  availability_zones = var.azs
  enabled            = var.enabled
  name               = join("-", [var.name, "vpc-tgw-subnet"])
  new_bits           = "2"
  source = "../vpc_subnets?ref=v0.0.1"
  subnet_cidr        = cidrsubnet(var.cidr_block, var.subnet_tier_bits, var.tgw_subnet_index)
  tags               = merge(var.tags, map("Name", var.name))
  vpc_id             = module.vpc.vpc_id
}

# vpc private subnets module
module "vpc_private_subnets" {
  availability_zones = var.azs
  enabled            = var.enabled
  name               = join("-", [var.name, "vpc-private-subnet"])
  new_bits           = "2"
  source = "../vpc_subnets?ref=v0.0.1"
  subnet_cidr        = cidrsubnet(var.cidr_block, var.subnet_tier_bits, var.private_subnet_index)
  tags               = merge(var.tags, map("Name", var.name))
  vpc_id             = module.vpc.vpc_id
}

# vpc data subnets module
module "vpc_data_subnets" {
  #availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  availability_zones = var.azs
  enabled            = var.enabled
  name               = join("-", [var.name, "vpc-data-subnet"])
  new_bits           = "2"
  source = "../vpc_subnets?ref=v0.0.1"
  subnet_cidr        = cidrsubnet(var.cidr_block, var.subnet_tier_bits, var.data_subnet_index)
  tags               = merge(var.tags, map("Name", var.name))
  vpc_id             = module.vpc.vpc_id
}

# vpc route table
module "vpc_route_table" {
  enabled = var.enabled
  name    = join("-", [var.name, "vpc-route-table"])
  source = "../route_table?ref=v0.0.1"
  tags    = merge(var.tags, map("Name", var.name))
  vpc_id  = module.vpc.vpc_id
}

# vpc route table main route table association
module "vpc_route_table_main_route_table_association" {
  enabled        = var.enabled
  name           = join("-", [var.name, "vpc-route-table-main-route-table-association"])
  source = "../main_route_table_association?ref=v0.0.1"
  tags           = merge(var.tags, map("Name", var.name))
  route_table_id = module.vpc_route_table.id
  vpc_id         = module.vpc.vpc_id
}

# vpc internet gateway 
module "vpc_igw" {
  enabled = var.enabled
  name    = join("-", [var.name, "vpc-igw"])
  source = "../internet_gateway?ref=v0.0.1"
  tags    = merge(var.tags, map("Name", var.name))
  vpc_id  = module.vpc.vpc_id
}

# vpc route for internet gateway
module "vpc_route_for_igw" {
  enabled                = var.enabled
  name                   = join("-", [var.name, "vpc-route-for-igw"])
  source = "../route?ref=v0.0.1"
  tags                   = merge(var.tags, map("Name", var.name))
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc_igw.id
  route_table_id         = module.vpc_route_table.id
}
