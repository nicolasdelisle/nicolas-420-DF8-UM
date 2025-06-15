variable "region" {
  description = "AWS region to deploy to"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the existing EC2 Key Pair to use"
  default     = "nicolas"
}

variable "security_group_name" {
  description = "The name of the existing security group"
  default     = "web-sg"
}