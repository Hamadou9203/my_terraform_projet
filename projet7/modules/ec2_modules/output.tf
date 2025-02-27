output "sortie_ec2_id" {
    value = aws_instance.ec2.id
  
}
output "sortie_ec2_pub" {
    value = aws_instance.ec2.public_ip
  
}