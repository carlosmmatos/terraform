variable "instance_name" {
  description = "Name of the instance"
  type        = string
}

variable "ami_ssm_parameter" {
  description = "SSM parameter name for the AMI ID"
  default     = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.medium"
}

variable "ssh_key_name" {
  description = "AWS SSH key name"
  type        = string
}

variable "get_password_data" {
  description = "Get password data for the instance, useful for windows instances"
  type        = bool
  default     = false
}

variable "region" {
  description = "The AWS region to use"
  type        = string
  default     = "us-east-1"
}
