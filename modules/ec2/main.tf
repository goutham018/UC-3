resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_instance" "this" {
  ami                  = var.ami
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  user_data            = var.user_data
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    Name = var.name
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = var.target_group_arn # Ensure this is passed correctly
  target_id        = aws_instance.this.id
  port             = 80
}