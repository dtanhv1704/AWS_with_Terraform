provider "aws" {
  shared_credentials_file = ".aws/Cred/accessKeys.csv"
  region                  = "ap-southeast-1"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source        = "./vpc"
  vpc_cidr      = "192.168.0.0/16"
  public_cidrs  = ["192.168.1.0/24", "192.168.2.0/24"]
  private_cidrs = ["192.168.253.0/24", "192.168.254.0/24"]
}

module "ec2" {
  source         = "./ec2"
  instance_type  = "t2.micro"
  security_group = "${module.vpc.security_group}"
  subnets        = "${module.vpc.public_subnets}"
}
module "elb" {
  source = "./elb"
  instance2_id = "${module.ec2.instance2_id}"
  instance1_id = "${module.ec2.instance1_id}"
  subnet1      = "${module.vpc.public_subnet1}"
  subnet2      = "${module.vpc.public_subnet2}"
  vpc_id = "${module.vpc.vpc_id}"
  security_group = "${module.vpc.security_group}"
}
