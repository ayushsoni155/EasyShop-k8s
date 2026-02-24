variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}
variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "../easyshop-ssh-key.pub"
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-03446a3af42c5e74e"
}
variable "instance" {
  type = map(object({
    name            = string
    description     = string
    instance_type   = string
    volume_size     = number
    security_groups = string
    user_data       = string
  }))
  default = {
     "easyshop" = {
      "name"            = "easyshop"
      "description"     = "EasyShop EC2 instance"
      "instance_type"   = "m7i-flex.large"
      "volume_size"     = 30
      "security_groups" = "easyshop-sg"
      "user_data"       = "../scripts/kind.sh"
    },
    "jenkins-agent" = {
      "name"            = "jenkins-agent"
      "description"     = "EasyShop EC2 instance"
      "instance_type"   = "m7i-flex.large"
      "volume_size"     = 20
      "security_groups" = "jenkins-sg"
      "user_data"       = "../scripts/install_docker_&_java.sh"
    },
    "jenkins-ec2" = {
      "name"            = "jenkins-ec2"
      "description"     = "Jenkins EC2 instance"
      "instance_type"   = "t3.small"
      "volume_size"     = 10
      "security_groups" = "jenkins-sg"
      "user_data"       = "../scripts/install_jenkins.sh"
    }
  }
  description = "EasyShop EC2 instance"
}
