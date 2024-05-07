

module "globalvars" {
  source = "../../../modules/globalvars"
}


locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

module "vpc-prod" {
  source = "../../../modules/aws_network"
  env               = var.env
  vpc_cidr          = var.vpc_cidr
  private_cidr_blocks = var.private_cidr_blocks
  prefix              = local.name_prefix
  default_tags        = local.default_tags
  public_subnet              = false
  nat_gateway                = false
  internet_gateway           = false

}
