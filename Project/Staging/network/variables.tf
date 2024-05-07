# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Ranjith",
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "project"
  description = "Name prefix"
}

# Staging VPC - public subnet
variable "public_cidr_blocks" {
  default     = ["10.1.1.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# staging  VPC - private subnet
variable "private_cidr_blocks" {
  default     = ["10.1.2.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}


# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "VPC to host static web site"
}

# Variable to signal the current environment 
variable "env" {
  default     = "staging"
  type        = string
  description = "Deployment Environment"
}

