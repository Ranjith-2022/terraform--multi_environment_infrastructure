
#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Use remote state to retrieve the data
data "terraform_remote_state" "network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "terraform-project-12"      // Bucket from where to GET Terraform State
    key    = "prod-network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                            // Region where bucket created
  }
}


# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
  name_prefix  = "${var.prefix}-${var.env}"
}



variable "instance_names" {
  type        = list(string)
  description = "List of instance names"
  default     = ["VM3", "VM4"]
}

# --------------------------------------------------------------------- VM Instances -----------------------------------------------------------------------------------------------------------------

resource "aws_instance" "my_amazon" {
  count = length(data.terraform_remote_state.network.outputs.private_subnet_ids)

  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_ids[count.index]
  security_groups             = [aws_security_group.sg.id]
  associate_public_ip_address = false

  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags, {
    "Name" = "${local.name_prefix}-Amazon-Linux-${var.instance_names[count.index]}"
  }
  )
}


# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = local.name_prefix
  public_key = file("${local.name_prefix}.pub")
}


# Security Group
resource "aws_security_group" "sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description      = "SSH from Staging"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.1.1.0/24"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-sg-VM3"
    }
  )
}

#------------------------------------------------------------------------ VPC Peering --------------------------------------------------------------------------------


data "terraform_remote_state" "network_staging" { 
  backend = "s3"
  config = {
    bucket = "terraform-project-12"        
    key    = "staging-network/terraform.tfstate"  
    region = "us-east-1"                            
  }
}

# VPC Peering 
resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id         = data.terraform_remote_state.network_staging.outputs.vpc_id
  peer_vpc_id    = data.terraform_remote_state.network.outputs.vpc_id
  auto_accept    = var.vpc_peering_config.auto_accept
  tags = {
    Name = "VPC Peering Connection"
  }
}

# VPC Peering Connection Accepter
resource "aws_vpc_peering_connection_accepter" "vpc_peering_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}


