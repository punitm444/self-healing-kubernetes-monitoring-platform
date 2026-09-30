output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "k3s_instance_id" {
  value = aws_instance.k3s.id
}

output "k3s_public_ip" {
  value = aws_instance.k3s.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}