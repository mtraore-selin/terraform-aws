
# resource "aws_instance" "web" {
#   ami           = "ami-0c1ac8a41498c1a9c"
#   instance_type = "t3.micro"

#   tags = {
#     Name = "baragnini"
#   }

#   root_block_device {
#     delete_on_termination = true
#   }
# }

provider "aws" {
  region = "eu-north-1"
}

resource "aws_iam_role" "ssm_role" {
  name = "ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_instance" "web" {
  ami                  = "ami-0c1ac8a41498c1a9c"
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    Name = "baragnini"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
              sudo yum install -y nodejs
              EOF

  root_block_device {
    delete_on_termination = true
  }
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
