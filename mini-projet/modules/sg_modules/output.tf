
output "sortie_sg" {
  value = aws_security_group.allow_http_https_ssh.name
}