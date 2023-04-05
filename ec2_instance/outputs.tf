## Ip Address of the ec2 instance
output "public_ip" {
  value = module.ec2_instance.public_ip
}
