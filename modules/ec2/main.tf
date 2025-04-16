resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  user_data     = var.user_data

  tags = {
    Name = var.name
  }
}

output "instance_id" {
  value = aws_instance.this.id
}

output "instance_private_ip" {
  value = aws_instance.this.private_ip
}