//Variables in separate files

terraform {
  backend "s3" {
    bucket = "mvanderpauw-terraform-state"
    key = "demo/demostack"
    region = "eu-west-1"
  }
}


provider "aws" {
  region = var.region
}

resource "aws_instance" "ubuntu-example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instancetype
  key_name      = "mvanderpauw"
  subnet_id = "subnet-92cf87c8"

  vpc_security_group_ids = ["sg-a06dadfa"]

  tags = {
    Name = "martijn-rs-test3"
    Stack = "${var.stackname}-${var.env}"
    Team = var.teamname
    Environment = var.env
  }
  user_data = file("install_nginx.sh")
}

resource "aws_elb" "load-balancer" {
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  instances = [aws_instance.ubuntu-example.id]

  tags = {
    Name = "martijn-rs-test-elb3"
    Stack = var.stackname
    Team = var.teamname
  }
}

resource "aws_route53_record" "www" {
  zone_id = "Z09336113V7JQ1DGESXYI"
  name    = "rs-test3.decentwave.net"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.load-balancer.dns_name]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}