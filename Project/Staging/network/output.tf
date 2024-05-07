

output "public_subnet_ids" {
  value = module.vpc-stag.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc-stag.private_subnet_ids
}

output "vpc_id" {
  value = module.vpc-stag.vpc_id
}

