output "instance_id" {
  value = aws_instance.ec2_ftp.id
}

output "instance_public_ip" {
  value = aws_instance.ec2_ftp.public_ip
}