

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
    key    = "staging-network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                            // Region where bucket created
  }
}


# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

# Retrieve global variables from the Terraform module
module "globalvars"{
  source = "../../../modules/globalvars"
}

#------------------------------------------------------------------------ VM2 Instance --------------------------------------------------------------------------------

resource "aws_instance" "my_amazon" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_ids[0]
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(local.prefix)
    }
  )

  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-VM2"
    }
  )
}


# VM 2 Security Group

resource "aws_security_group" "web_sg" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "HTTP from bastion"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.bastion.private_ip}/32", "${aws_instance.bastion.public_ip}/32"]
  }

  ingress {
    description = "SSH from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.bastion.private_ip}/32", "${aws_instance.bastion.public_ip}/32"]
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
      "Name" = "${local.name_prefix}-sg"
    }
  )
}

#------------------------------------------------------------------------ Bastion Instance --------------------------------------------------------------------------------
# server  deployment
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(local.prefix)
    }
  )


  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-Amazon-bastion-VM1"
    }
  )
}


# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = local.name_prefix
  public_key = file("${local.name_prefix}.pub")
}


# Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "allow_sshh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

 ingress {
    description = "SSH from private IP of CLoud9 machine"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_private_ip}/32", "${var.my_public_ip}/32"]
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
      "Name" = "${local.name_prefix}-sg"
    }
  )
}



