resource "aws_ebs_volume" "rex_volume" {
  availability_zone = var.rex_az
  size              = var.rex_volume_size

  tags = {
    Name = var.rex_volume_name
  }

}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.rex_volume.id
  instance_id = var.rex_instance_id
}