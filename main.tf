module "vpc" {
  source                = "./modules/vpc"
  name                  = "custom-vpc"
  cidr_block            = "10.0.0.0/16"
  public_subnet_count   = 3
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  availability_zones    = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

module "alb" {
  source          = "./modules/alb"
  name            = "my-alb"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = module.vpc.public_subnet_ids
  vpc_id          = module.vpc.vpc_id
}

module "ec2_a" {
  source          = "./modules/ec2"
  name            = "instance-a"
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnet_ids[0]
  vpc_id          = module.vpc.vpc_id
  target_group_arn = module.alb.target_group_arn
  user_data       = <<-EOF
                    #!/bin/bash
                    apt-get update
                    apt-get install -y nginx
                    echo "Hello from Instance A" > /var/www/html/index.html
                    systemctl start nginx
                    EOF
}

module "ec2_b" {
  source          = "./modules/ec2"
  name            = "instance-b"
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnet_ids[1]
  vpc_id          = module.vpc.vpc_id
  target_group_arn = module.alb.target_group_arn
  user_data       = <<-EOF
                    #!/bin/bash
                    apt-get update
                    apt-get install -y nginx
                    mkdir -p /var/www/html/images
                    echo "Hello from Instance B" > /var/www/html/images/index.html
                    systemctl start nginx
                    EOF
}

module "ec2_c" {
  source          = "./modules/ec2"
  name            = "instance-c"
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnet_ids[2]
  vpc_id          = module.vpc.vpc_id
  target_group_arn = module.alb.target_group_arn
  user_data       = <<-EOF
                    #!/bin/bash
                    apt-get update
                    apt-get install -y nginx
                    mkdir -p /var/www/html/register
                    echo "Hello from Instance C" > /var/www/html/register/index.html
                    systemctl start nginx
                    EOF
}