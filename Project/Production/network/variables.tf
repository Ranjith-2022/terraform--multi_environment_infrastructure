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

variable "public_cidr_blocks" {
  type        = list(string)
  default     = []
  description = ""
}


# production  VPC - private subnet
variable "private_cidr_blocks" {
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
  type        = list(string)
  description = "Production Private Subnet CIDRs"
}
# VPC CIDR range
variable "vpc_cidr" {
   default     =  "10.10.0.0/16"
  type        = string
  description = "VPC to host static web site"
}

# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}

