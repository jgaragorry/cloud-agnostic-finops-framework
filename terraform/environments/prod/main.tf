terraform {
  required_version = ">= 1.0.0"
  backend "s3" {
    bucket         = "finops-tfstate-533267117128"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-lock"
    encrypt        = true
  }
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  features {}
}

# --- Búsqueda dinámica de la AMI de Ubuntu 24.04 ---
data "aws_ami" "ubuntu_24_04" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "finops_node" {
  ami           = data.aws_ami.ubuntu_24_04.id
  instance_type = "t3.micro"
  tags = {
    Name        = "FinOps-Node"
    CostCenter  = "LinkedIn-Lab"
    Project     = "Cloud-Agnostic-FinOps"
  }
}

resource "azurerm_resource_group" "finops_rg" {
  name     = "finops-rg"
  location = "East US"
  tags = {
    CostCenter = "LinkedIn-Lab"
  }
}
