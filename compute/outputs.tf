# compute/outputs.tf

output "si3mshady_ec2_instances" {
    value = aws_instance.si3mshadyEC2[*]
    sensitive = true 
}

output "appPort" {
    value = 5000
}