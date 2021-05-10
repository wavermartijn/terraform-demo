//Basic demo
//
terraform {
  backend "s3" {
//    bucket = "mvanderpauw-terraform-state"
//    key = "demo/stack1"
//    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}


resource "aws_instance" "ubuntu-example" {

  ami           = "ami-0aef57767f5404a3c"
  instance_type = "t2.micro"
  key_name      = "mvanderpauw2"
  subnet_id = "subnet-92cf87c8"

  vpc_security_group_ids = ["sg-a06dadfa"]

  tags = {
    Name  = "wordpress-${var.teamname}-${var.env}"
    Stack = var.stackname
    Team  = var.teamname
  }
  lifecycle {
    ignore_changes = [user_data]
  }
  user_data = file("install_wordpress.sh")
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

    Name  = "wordpress-${var.teamname}-${var.env}"
    Stack = var.stackname
    Team  = var.teamname
  }
}


resource "aws_route53_record" "www" {
  zone_id = "Z09336113V7JQ1DGESXYI"
  name    = var.dnsname1
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.load-balancer.dns_name]
}
resource "aws_route53_record" "www2" {
  zone_id = "Z09336113V7JQ1DGESXYI"
  name    = var.dnsname2
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.load-balancer.dns_name]
}


# Luca
resource "aws_instance" "ubuntu-luca" {

  ami           = "ami-0aef57767f5404a3c"
  instance_type = "t2.micro"
  key_name      = "mvanderpauw2"

  subnet_id = "subnet-92cf87c8"

  vpc_security_group_ids = ["sg-a06dadfa"]

  tags = {
    Name  = "wordpress-${var.teamname}-${var.env}"
    Stack = var.stackname-luca
    Team  = var.teamname
  }
  lifecycle {
    ignore_changes = [user_data]
  }
  user_data = file("install_wordpress.sh")
}


resource "aws_elb" "load-balancer-luca" {
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"

  }
  instances = [aws_instance.ubuntu-luca.id]

  tags = {

    Name  = "wordpress-${var.teamname}-${var.env}"
    Stack = var.stackname-luca
    Team  = var.teamname
  }
}

resource "aws_route53_record" "www-luca" {
  zone_id = "Z09336113V7JQ1DGESXYI"
  name    = var.dnsname-luca
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.load-balancer-luca.dns_name]
}
