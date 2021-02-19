#root/outputs 

output "instances" {
  value     = { for i in module.compute.si3mshady_ec2_instances : i.tags.Name => "http://${i.public_ip}:${module.compute.appPort}" }
  sensitive = true
}

