# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "test"    = "t3.micro"
    "staging" = "t2.micro"
    "dev"     = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Prefix to identify resources
variable "prefix" {
  default     = "project"
  type        = string
  description = "Name prefix"
}

# Variable to signal the current environment 
variable "env" {
  default     = "staging"
  type        = string
  description = "Deployment Environment"
}


variable "my_private_ip" {
  type        = string
  default     = "172.31.78.99"
  description = "Private IP of my Cloud 9 station to be opened in bastion ingress"
}

# curl http://169.254.169.254/latest/meta-data/public-ipv4
variable "my_public_ip" {
  type        = string
  default     = "18.232.51.92"
  description = "Public IP of my Cloud 9 station to be opened in bastion ingress"
}
