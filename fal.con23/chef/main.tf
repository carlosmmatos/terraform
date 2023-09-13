provider "aws" {
  region = local.region
}

data "http" "ip" {
  url    = "https://ipinfo.io"
  method = "GET"
}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "defaultForAz"
    values = ["true"]
  }
}

locals {
  region = var.region
  ip     = jsondecode(data.http.ip.response_body)["ip"]
}

resource "aws_security_group" "this" {
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.ip}/32"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"

  name                        = var.instance_name
  ami_ssm_parameter           = var.ami_ssm_parameter
  associate_public_ip_address = true
  get_password_data           = var.get_password_data
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  user_data                   = <<-EOF
                                #!/bin/bash
                                hostnamectl set-hostname ${var.instance_name}
                                wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
                                echo 'export CHEF_LICENSE="accept"' >> ~/.bashrc
                                dpkg -i chef-workstation_21.10.640-1_amd64.deb
                                echo 'eval "$(chef shell-init bash)"' >> ~/.bashrc
                                mkdir /root/cookbooks
                                cat << END > /root/.gitconfig
                                [user]
                                  email = root@example.com
                                  name = root man
                                END
                                EOF

  subnet_id              = data.aws_subnets.default_subnets.ids[0]
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    Environment = "fal-con-demo-23"
    Demo = "chef"
  }
}
