provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "tfguard-test-insecure-bucket"
  acl    = "private" # Remedied: Restricted access

  tags = {
    Name        = "Secured Bucket"
    Environment = "Test"
  }

  lifecycle_rule {
    id      = "cleanup-old-objects"
    enabled = true

    expiration {
      days = 90
    }
  }
}

resource "aws_security_group" "secure_sg" {
  name        = "secure_sg"
  description = "Allow only HTTPS inbound"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] # Remedied: Restricted to internal network
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
