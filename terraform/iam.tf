resource "aws_iam_role" "ec2_role" {
  name = "self-healing-platform-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name    = "self-healing-platform-ec2-role"
    Project = "self-healing-kubernetes-platform"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "self-healing-platform-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name    = "self-healing-platform-ec2-profile"
    Project = "self-healing-kubernetes-platform"
  }
}

resource "aws_iam_role_policy" "ecr_push" {
  name = "self-healing-platform-ecr-push"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "ecr:DescribeRepositories"
        ]

        Resource = "*"
      },
      

      {
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage"
        ]

        Resource = aws_ecr_repository.app.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecr_pull" {
  name = "self-healing-platform-ecr-pull"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeImages"
        ]

        Resource = aws_ecr_repository.app.arn
      }
    ]
  })
}
