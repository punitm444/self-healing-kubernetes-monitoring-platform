resource "aws_ecr_repository" "app" {
  name                 = "self-healing-platform"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "self-healing-platform"
    Project     = "self-healing-kubernetes-platform"
    Environment = "dev"
  }
}