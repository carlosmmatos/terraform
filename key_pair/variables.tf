variable "ssh_key_name" {
  description = "Local SSH key name to use for the instance"
  type        = string
}

variable "ssh_key_path" {
  description = "Local SSH key path to use for the instance"
  default     = "~/.ssh/"
  type        = string
}

variable "region" {
  description = "The AWS region to use"
  default     = "us-east-1"
  type        = string
}
