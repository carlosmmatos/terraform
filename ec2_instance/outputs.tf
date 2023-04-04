# Uncomment to get the b64 encoded password for Windows instances
#
#output "get_password_data" {
#  value = module.ec2_instance.password_data
#}

# Public IP address of the instance
output "get_public_ip" {
  value = module.ec2_instance.public_ip
}
