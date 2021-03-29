/*
resource "aws_ebs_volume" "volume" {
  availability_zone = aws_instance.validator.availability_zone
  type              = "gp2"
  size              = 50
}

resource "aws_volume_attachment" "volume-attachment" {
  device_name = "/dev/xvdb"
  instance_id = aws_instance.validator.id
  volume_id   = aws_ebs_volume.volume.id
#  skip_destroy = true

}
resource "template_file" "userdata" {
    template = "provision.sh"
}
*/
resource "aws_instance" "validator" {

  ami                         = var.image_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.ssh_key
  vpc_security_group_ids      = [ 
      aws_security_group.ssh.id, 
      aws_security_group.p2p.id, 
      aws_security_group.prometheus.id 
  ]
  subnet_id                   = module.vpc.public_subnets[0]
  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = 50
  }
  tags                        = {
    Name                      = "node"
  }
  
  provisioner "file" {
    source                    = "provision.sh"
    destination               = "$HOME/provision.sh"
    connection {
      type                    = "ssh"
      host                    = self.public_ip
      user                    = var.user
      private_key             = file("~/.ssh/id_rsa")
    }
  }
  provisioner "remote-exec" {
    inline                    = [
      "chmod +x $HOME/provision.sh",
      "$HOME/provision.sh",
    ]
    connection {
      type                    = "ssh"
      host                    = self.public_ip
      user                    = var.user
      private_key             = file("~/.ssh/id_rsa")
    }
  }
  

}

resource "aws_security_group" "ssh" {

  name_prefix                 = module.vpc.name
  description                 = "SG to be applied to validator instance"
  vpc_id                      = module.vpc.vpc_id

  ingress {
    from_port                 = 22
    to_port                   = 22
    protocol                  = "tcp"
    cidr_blocks               = ["0.0.0.0/0"]
  }
  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "p2p" {

  name_prefix                 = module.vpc.name
  description                 = "SG to be applied to validator instance"
  vpc_id                      = module.vpc.vpc_id

  ingress {
    from_port                 = 26656
    to_port                   = 26656
    protocol                  = "tcp"
    cidr_blocks               = ["0.0.0.0/0"]
  }
  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "prometheus" {

  name_prefix                 = module.vpc.name
  description                 = "SG to be applied to validator instance"
  vpc_id                      = module.vpc.vpc_id

  ingress {
    from_port                 = 26660
    to_port                   = 26660
    protocol                  = "tcp"
    cidr_blocks               = ["0.0.0.0/0"]
  }
  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["0.0.0.0/0"]
  }
}