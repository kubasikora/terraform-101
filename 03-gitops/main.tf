terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.11.0"
    }
  }

  backend "s3" {
    bucket = "techday-terraform"
    key    = "gitops-server/terraform.tfstate"
    region = "eu-central-1"
    shared_credentials_file = "../config/.credentials"
  }
}

provider "aws" {
  region                   = "eu-central-1"
  shared_credentials_files = ["../config/.credentials"]
}

resource "aws_instance" "gitops" {
  ami               = "ami-0d527b8c289b4af7f"
  instance_type     = "t2.micro"
  availability_zone = "eu-central-1a"
  key_name          = "TechDay"
  security_groups = [ "gitops_server" ]

  tags = {
    Name = "TechDay gitops server v2"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.gitops.id
  allocation_id = aws_eip.example.id
}

output "server_public_ip" {
  value = aws_eip.example.public_ip
}