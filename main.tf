module "vpc" {
  source                = "./modules/vpc"
  name                  = "custom-vpc"
  cidr_block            = "10.0.0.0/16"
  public_subnet_count   = 3
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  availability_zones    = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

module "alb" {
  source          = "./modules/alb"
  name            = "my-alb"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = module.vpc.public_subnet_ids
}

module "ec2_a" {
  source          = "./modules/ec2"
  name            = "instance-a"
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnet_ids[0]
  user_data       = <<-EOF
                    #!/bin/bash
                    echo "Hello from Instance A" > /var/www/html/index.html
                    yum install -y nginx
                    systemctl start nginx
                    EOF
}

module "ec2_b" {
  source          = "./modules/ec2"
  name            = "instance-b"
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnet_ids[1]
  user_data       = <<-EOF
                    #!/bin/bash
                    echo "Hello from Instance B" > /var/www/html/images/index.html
                    yum install -y nginx
                    systemctl start nginx
                    EOF
}

module "ec2_c" {
  source          = "./modules/ec2"
  name            = "instance-c"
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnet_ids[2]
  user_data       = <<-EOF
                    #!/bin/bash
                    echo "Hello from Instance C" > /var/www/html/register/index.html
                    yum install -y nginx
                    systemctl start nginx
                    EOF
}