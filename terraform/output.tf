output "public_ip_dns" {
  value = {
    for instance in aws_instance.easyshop_instance : 
    instance.id => {
      name       = instance.tags.Name
      public_dns = instance.public_dns
      public_ip  = instance.public_ip
    }
  }
}