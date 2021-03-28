# AGORIC TOOLS
Tools for Agoric Network

## Terraform
Deploy a fulllnode for agoric validator to your AWS account

### Prerequisites
* Terraform 0.13 or later
* aws-cli installed
* aws account with access-key and secret-key
* ssh key called user in aws region 

### Parameters to configure
terraform.tfvars     
* image_id      = "ami-0d7b738ade930e24a" # ubuntu 20.04 ami in eu-west-3 region
* instance_type = "t2.medium" # 2 cpu and 4gb ram
* ssh_key       = "user"      # aws ssh keyname    
* user          = "ubuntu"    # aws instance username
* vpc_name      = "agoric"    # vpc name 
* region        = "eu-west-3" # select your prefered aws region
* profile       = "sandbox"   # your aws profile from ~/.aws/credentials

### Instruction
- Navigate to terraform directory
- Edit variables file terraform.tfvars 
- run *terraform init* to initialize modules
- run *terraform apply* to run the configuration
- press *yes* when apply changes
