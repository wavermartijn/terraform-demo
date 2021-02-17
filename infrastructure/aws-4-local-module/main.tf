// Basic module

terraform {
  backend "s3" {
    bucket = "mvanderpauw-terraform-state"
    key = "demo/local-module"
    region = "eu-west-1"
  }
}


provider "aws" {
  region = var.region
}

//module "website_s3_bucket" {
//  source = "../modules/aws-s3-static-website-bucket"
//
//  bucket_name = "rockstars-terraform-demo-bucket"
//
//  tags = {
//    Terraform   = "true"
//    Environment = var.env
//  }
//}

//resource "aws_instance" "ubuntu-example" {
//  ami           = data.aws_ami.ubuntu.id
//  instance_type = var.instancetype
//  key_name      = "mvanderpauw"
//  subnet_id = "subnet-92cf87c8"
//
//  vpc_security_group_ids = ["sg-a06dadfa"]
//
//  tags = {
//    Name = "martijn-rs-test3"
//    Stack = "${var.stackname}-${var.env}"
//    Team = var.teamname
//    Environment = var.env
//  }
//  user_data = file("install_nginx.sh")
//}

resource "aws_elb" "load-balancer" {
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

//  instances = [aws_instance.ubuntu-example.id]
  //instances = [module.ec2-instance[*].id]
  instances =  module.ec2-instance[*].id
//  instances = flatten([
//        module.ec2-instance[*].id,
//  ])

  tags = {
    Name = "martijn-rs-test-elb3"
    Stack = var.stackname
    Team = var.teamname
  }
}
module "ec2-instance" {
  source = "../modules/aws-ec2-instance"
  env = var.env
  count = 3
  stackname = var.stackname
  teamname = var.stackname

}
resource "aws_route53_record" "www" {
  zone_id = "Z09336113V7JQ1DGESXYI"
  name    = "rs-test3.decentwave.net"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.load-balancer.dns_name]
}

//data "aws_ami" "ubuntu" {
//  most_recent = true
//
//  filter {
//    name   = "name"
//    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
//  }
//
//  filter {
//    name   = "virtualization-type"
//    values = ["hvm"]
//  }
//
//  owners = ["099720109477"] # Canonical
//}