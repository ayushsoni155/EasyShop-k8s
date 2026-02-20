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
variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "m7i-flex.large"
}
variable "volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}