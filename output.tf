# Primary requirement: Public IP of the web server
output "web_public_ip" {
  description = "Public IP address of the Web Server EC2 instance"
  value       = aws_instance.web.public_ip
}

# Helpful addition: Private IP of the DB server (needed for jump host SSH)
output "db_private_ip" {
  description = "Private IP address of the Database EC2 instance"
  value       = aws_instance.db.private_ip
}

# Ready-to-run SSH command for the public web server
output "ssh_web_command" {
  description = "Command to SSH into the Web Server"
  value       = "ssh -i assignment-key.pem ubuntu@${aws_instance.web.public_ip}"
}
