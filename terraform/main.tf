provider aws {
  version = "3.22.0"
  region  = var.region
  profile = var.profile
}

data aws_availability_zones azs {}
data aws_caller_identity current {}
data aws_region current {}