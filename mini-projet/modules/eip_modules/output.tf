
output "sortie_publique" {
  value = aws_eip.lb.id
}

output "sortie_eippub" {
  value = aws_eip.lb.public_dns
}