output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ubuntu_ec2.id
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ubuntu_ec2.public_ip
}

output "security_group_used" {
  description = "The security group applied to the instance"
  value       = data.aws_security_group.existing_web_sg.id
}