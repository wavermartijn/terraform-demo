//Basic demo
//
terraform {
  backend "s3" {
    bucket = "mvanderpauw-terraform-state"
    key = "demo/demostack"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "ubuntu-example" {
  ami           = "ami-0aef57767f5404a3c"
  instance_type = "t2.micro"
  key_name      = "mvanderpauw"
  subnet_id = "subnet-92cf87c8"


  vpc_security_group_ids = ["sg-a06dadfa"]

  tags = {
    Name = "martijn-rs-test"
    Stack = "demo"
    Team = "demo"
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
    Name = "martijn-rs-test-elb"
    Stack = "demo"
    Team = "demo"
  }
}

resource "aws_route53_record" "www" {
  zone_id = "Z09336113V7JQ1DGESXYI"
  name    = "rs-test.decentwave.net"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.load-balancer.dns_name]
}