module vpc {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name    = var.vpc_name 
  cidr    = "10.0.0.0/20"
  azs = [
    data.aws_availability_zones.azs.names[0],
    data.aws_availability_zones.azs.names[1],
    data.aws_availability_zones.azs.names[2]
  ]
  # one private subnet per AZ
  private_subnets        = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  # one public subnet per AZ
  public_subnets         = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true
  enable_dns_support     = true
  tags                   = { 
      Name = var.vpc_name  
  }

}