provider "aws" {
  region = local.region
}

locals {
  region = var.region
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = var.ssh_key_name
  public_key = file("${var.ssh_key_path}${var.ssh_key_name}.pub")
}
