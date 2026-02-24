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
resource "aws_security_group" "easyshop-sg" {
      name        = "easyshop-sg"
      description = "Security group for EasyShop EC2 instances"
      ingress{
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow SSH traffic"
        }
        ingress{
          from_port   = 80
          to_port     = 80
          protocol  = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow HTTP traffic"
        }
        ingress{
          from_port   = 443
          to_port     = 443
          protocol  = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow HTTPS traffic"
        }
        ingress{
          from_port   = 3000
          to_port     = 3000
          protocol  = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow HTTPS traffic"
        }
      egress{
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
resource "aws_security_group" "jenkins-sg" {
      name        = "jenkins-sg"
      description = "Security group for Jenkins EC2 instance"
      ingress{
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow SSH traffic"
        }
        ingress{
          from_port   = 8080
          to_port     = 8080
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow Jenkins HTTP traffic"
        }
      egress{
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow all outbound traffic"
        }
      tags = {
        Name = "jenkins-sg"
      }
}
# EC2 instance
resource "aws_instance" "easyshop_instance" {
  for_each        = var.instance
  ami             = var.ami_id
  instance_type   = each.value.instance_type
  key_name        = aws_key_pair.easyshop_ssh_key.key_name
  security_groups = [each.value.security_groups]
  user_data       = file(each.value.user_data)
  root_block_device {
    volume_size = each.value.volume_size
    volume_type = "gp3"
  }
  tags = {
    Name = each.value["name"]
  }
}
resource "aws_ec2_instance_state" "easyshop_instance_state" {
  for_each = var.instance
  instance_id = aws_instance.easyshop_instance[each.value.name].id
  state       = "running"
}
