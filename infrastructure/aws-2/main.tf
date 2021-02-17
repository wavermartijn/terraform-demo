//Variables

terraform {
  backend "s3" {
    bucket = "mvanderpauw-terraform-state"
    key = "demo/stack2"
    region = "eu-west-1"
  }
}


provider "aws" {
  region = var.region
}

resource "aws_instance" "ubuntu-example2" {

  ami           = "ami-0aef57767f5404a3c"
  instance_type = var.instancetype
  key_name      = "mvanderpauw"
  subnet_id = "subnet-92cf87c8"


  vpc_security_group_ids = ["sg-a06dadfa"]

  tags = {
    Name = "martijn-rs-test2"
    Stack = var.stackname
    Team = var.teamname
  }
  user_data = file("install_nginx.sh")
}


resource "aws_elb" "load-balancer2" {
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  instances = [aws_instance.ubuntu-example2.id]

  tags = {
    Name = "martijn-rs-test-elb"
    Stack = var.stackname
    Team = var.teamname
  }
}

resource "aws_route53_record" "rs-test2" {
  zone_id = "Z09336113V7JQ1DGESXYI"
  name    = "rs-test2.decentwave.net"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.load-balancer2.dns_name]
}