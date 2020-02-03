provider "aws" {
  shared_credentials_file = ".aws/Cred/accessKeys.csv"
  region                  = "ap-southeast-1"
}
data "aws_availability_zones" "available" {}
resource "aws_key_pair" "public_key" {
  key_name   = "public_key"
  public_key = "${file(var.public_key)}"
}
data "template_file" "bootstrap" {
  template = "${file("./bootstrap.tpl")}"
}
resource "aws_instance" "hung_terraform_ubuntu" {
  count = 2
  ami   = "ami-0ee0b284267ea6cde" //ubuntu 16.04 LTS
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.public_key.id}"
  vpc_security_group_ids = ["${var.security_group}"]
  subnet_id = "${element(var.subnets, count.index )}"
  user_data = "${(data.template_file.bootstrap.rendered)}"
  //depends_on = ["aws_security_group.hung_sg", "aws_subnet.public_subnet"]
  
  tags = {
    Name = "Canh-Rau-Den-${count.index +1}"
  }
}
