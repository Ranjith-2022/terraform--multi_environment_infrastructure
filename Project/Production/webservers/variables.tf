# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t2.micro"
    "test"    = "t2.micro"
    "staging" = "t2.micro"
    "dev"     = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Ranjith"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Prefix to identify resources
variable "prefix" {
  default     = "project"
  type        = string
  description = "Name prefix"
}


# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}


variable "vpc_peering_config" {
  description = "Configuration for VPC peering"
  type = object({
    requester_vpc_id    = string
    accepter_vpc_id     = string
    auto_accept         = bool
    peer_owner_id       = string
  })
  default = {
    requester_vpc_id    = ""
    accepter_vpc_id     = ""
    auto_accept         = true
    peer_owner_id       = ""
  }
}


