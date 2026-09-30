# ---------------------------------
# Jenkins Security Group
# ---------------------------------

resource "aws_security_group" "jenkins" {
  name        = "self-healing-jenkins-sg"
  description = "Security group for Jenkins server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name    = "self-healing-jenkins-sg"
    Project = "self-healing-kubernetes-platform"
  }
}

# SSH
resource "aws_vpc_security_group_ingress_rule" "jenkins_ssh" {
  security_group_id = aws_security_group.jenkins.id

  cidr_ipv4 = "101.0.63.46/32"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  description = "SSH access"
}

# Jenkins Web UI
resource "aws_vpc_security_group_ingress_rule" "jenkins_web" {
  security_group_id = aws_security_group.jenkins.id

  cidr_ipv4 = "101.0.63.46/32"
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
  description = "Jenkins web interface"
}

# Outbound traffic
resource "aws_vpc_security_group_egress_rule" "jenkins_all_outbound" {
  security_group_id = aws_security_group.jenkins.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
  description = "Allow outbound traffic"
}


# ---------------------------------
# K3s Security Group
# ---------------------------------

resource "aws_security_group" "k3s" {
  name        = "self-healing-k3s-sg"
  description = "Security group for K3s Kubernetes server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name    = "self-healing-k3s-sg"
    Project = "self-healing-kubernetes-platform"
  }
}

# SSH
resource "aws_vpc_security_group_ingress_rule" "k3s_ssh" {
  security_group_id = aws_security_group.k3s.id

  cidr_ipv4 = "101.0.63.46/32"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  description = "SSH access"
}

# Kubernetes API


# HTTP
resource "aws_vpc_security_group_ingress_rule" "k3s_http" {
  security_group_id = aws_security_group.k3s.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  description = "HTTP application traffic"
}

# FastAPI
resource "aws_vpc_security_group_ingress_rule" "k3s_app" {
  security_group_id = aws_security_group.k3s.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8000
  to_port     = 8000
  ip_protocol = "tcp"
  description = "FastAPI application"
}

# Outbound traffic
resource "aws_vpc_security_group_egress_rule" "k3s_all_outbound" {
  security_group_id = aws_security_group.k3s.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
  description = "Allow outbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_from_k3s" {
  security_group_id            = aws_security_group.jenkins.id
  referenced_security_group_id = aws_security_group.k3s.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "Allow SSH from K3s server for Ansible"
}