resource "aws_ebs_volume" "volume" {
  availability_zone = var.az
  size              = var.volume_size

  tags = {
    Name = var.volume_name
  }

}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.volume.id
  instance_id = var.instance_id
}