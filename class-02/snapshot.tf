data "aws_instance" "ubuntu_instance" {
  instance_id = aws_instance.ubuntu_ec2.id
}

resource "aws_ebs_snapshot" "ubuntu_snapshot" {
  volume_id   = one([for d in data.aws_instance.ubuntu_instance.root_block_device : d.volume_id])
  description = "Snapshot of Ubuntu EC2 instance"

  tags = {
    Name = "apache-snapshot"
  }
}