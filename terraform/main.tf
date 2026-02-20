#SSH key
resource "aws_key_pair" "easyshop_ssh_key" {
  key_name   = "easyshop-ssh-key"
  public_key = file(var.ssh_public_key_path)
}
#vpc
resource "aws_default_vpc" "default" {
  tags = {
    Name = "easyshop-default-vpc"
  }
}
# security group
resource "aws_security_group" "easyshop_sg" {
  name        = "easyshop-sg"
  description = "Security group for EasyShop EC2 instances"
  vpc_id      = aws_default_vpc.default.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH traffic"
  }
  ingress {
    from_port   = 80   
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }
  ingress {
    from_port   = 443  
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  tags = {
    Name = "easyshop-sg"
  }
}
#EC2 instance
resource "aws_instance" "easyshop_instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = aws_key_pair.easyshop_ssh_key.key_name
    security_groups = [aws_security_group.easyshop_sg.name]
    user_data = file("../scripts/install_docker_&_kind.sh")
    root_block_device {
        volume_size = var.volume_size
        volume_type = "gp3"
    }
    tags = {
        Name = "easyshop-instance"
    }
}
resource "aws_ec2_instance_state" "easyshop_instance_state" {
    instance_id = aws_instance.easyshop_instance.id
    state = "running"
}