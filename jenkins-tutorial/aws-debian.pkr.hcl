packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "cyberware" {
  ami_name      = "daniel-cryptoware-01"
  instance_type = "t2.small"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "debian-stretch-hvm-x86_64-gp2-2022-03-25-58319"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["379101102735"]
  }
  ssh_username = "admin"
}

build {
  name = "daniel-cyberware-2022"
  sources = [
    "source.amazon-ebs.cyberware"
  ]
  provisioner "shell" {
    script = "./debian-setup.sh"
  }
}


