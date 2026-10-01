variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone to place subnets"
  type        = string
  default     = "ap-southeast-2a" # Ensure this matches your provider region
}

variable "my_ip" {
  description = "Your public IP address in CIDR format (e.g., 203.0.113.50/32)"
  type        = string
  # Replace 0.0.0.0/0 with your actual IP if preferred, or pass it via terraform.tfvars
  default     = "223.181.111.191/32"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
