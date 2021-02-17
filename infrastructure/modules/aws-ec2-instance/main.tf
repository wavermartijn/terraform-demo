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