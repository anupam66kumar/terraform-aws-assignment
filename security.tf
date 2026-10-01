# --- 1. IAM Role & Instance Profile ---
resource "aws_iam_role" "ec2_role" {
  name = "assignment-ec2-role"

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

# Attach standard AWS Systems Manager policy (lets you manage EC2 securely)
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "assignment-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# --- 2. Web Server Security Group (Public) ---
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow inbound SSH from my IP and HTTP"
  vpc_id      = aws_vpc.main.id

  # Inbound SSH restricted to your IP
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # Inbound HTTP (port 80)
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # React Frontend (Port 3000)
  ingress {
    description = "Frontend Port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Express Backend API (Port 3001)
  ingress {
    description = "Backend API Port"
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule (allow all egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "assignment-web-sg"
  }
}

# --- 3. Database Security Group (Private) ---
resource "aws_security_group" "db_sg" {
  name        = "db-server-sg"
  description = "Allow inbound traffic ONLY from Web Server SG"
  vpc_id      = aws_vpc.main.id

  # Inbound SSH only from Web Server Security Group (Bastion host jump)
  ingress {
    description     = "SSH from Web Server"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # Inbound MongoDB Port (27017) only from Web Server
  ingress {
    description     = "MongoDB access from Web Server"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # Outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "assignment-db-sg"
  }
}
