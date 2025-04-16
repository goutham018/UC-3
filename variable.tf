variable "ami" {
  description = "AMI ID for EC2 instances"
  type        = string
  default = "ami-084568db4383264d4"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default = "t2.micro"
}