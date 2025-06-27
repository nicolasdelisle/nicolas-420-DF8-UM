provider "aws" {
  region = "us-east-1"
}

variable "source_volume_id" {
  description = ""                                            #enter volume of ec2 located in ec2-instance-storage stat with vol-...
  type        = string
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_ebs_snapshot" "apache_snapshot" {
  volume_id   = var.source_volume_id
  description = "Snapshot of original Apache EC2 root volume"

  tags = {
    Name = "ApacheWebSnapshot"
  }
}

resource "aws_ebs_volume" "restored_volume" {
  availability_zone = "us-east-1a"  # Make sure this matches your new EC2 AZ
  snapshot_id       = aws_ebs_snapshot.apache_snapshot.id

  tags = {
    Name = "RestoredVolume"
  }
}

resource "aws_instance" "recovery_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  associate_public_ip_address = true
  key_name                    = "nicolas"  # Your keypair name

  user_data = <<-EOF
              #!/bin/bash
              sudo mkdir -p /mnt/restore
              # Wait for the volume device to be ready
              while [ ! -e /dev/xvdf1 ]; do sleep 1; done
              sudo mount /dev/xvdf1 /mnt/restore

              # Install Apache if needed
              sudo apt update -y
              sudo apt install apache2 -y

              # Stop default Apache site, replace with mounted website
              sudo systemctl stop apache2
              sudo rm -rf /var/www/html/*
              sudo ln -s /mnt/restore/var/www/html /var/www/html
              sudo systemctl start apache2
              EOF

  tags = {
    Name = "Apache-Restored-EC2"
  }
}

resource "aws_volume_attachment" "attach_restored" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.restored_volume.id
  instance_id = aws_instance.recovery_ec2.id
}
