# ---------------------------------
# Latest Ubuntu 24.04 LTS AMI
# ---------------------------------

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


# ---------------------------------
# Jenkins EC2
# ---------------------------------

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  key_name                    = "self-healing-platform-key"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.jenkins.id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"

    tags = {
      Name    = "jenkins-root-volume"
      Project = "self-healing-kubernetes-platform"
    }
  }

  tags = {
    Name        = "self-healing-platform-jenkins"
    Project     = "self-healing-kubernetes-platform"
    Role        = "jenkins"
    Environment = "dev"
  }
  lifecycle {
    ignore_changes = [ami]
  }
}


# ---------------------------------
# K3s EC2
# ---------------------------------

resource "aws_instance" "k3s" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  key_name                    = "self-healing-platform-key"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.k3s.id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"

    tags = {
      Name    = "k3s-root-volume"
      Project = "self-healing-kubernetes-platform"
    }
  }

  tags = {
    Name        = "self-healing-platform-k3s"
    Project     = "self-healing-kubernetes-platform"
    Role        = "k3s"
    Environment = "dev"
  }
  lifecycle {
    ignore_changes = [ami]
  }
}