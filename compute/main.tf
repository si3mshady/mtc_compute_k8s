# compute/main.tf


data "aws_ami" "si3mshady_ami" {
    most_recent = true
    owners = ["amazon"]
    
    filter {
        name = "name"
        values = ["ubuntu*"]
    }
}


resource "random_id" "rid" {
    byte_length = 2
    count = var.instance_count
   
}

resource "aws_key_pair" "si3mshadykp" {
    key_name = var.key_name
    public_key = file(var.public_key_path)
    
}


resource "aws_instance" "si3mshadyEC2" {

    count = var.instance_count #1
    instance_type = var.instance_type #t3.micro
    ami = data.aws_ami.si3mshady_ami.id
    tags = {
        Name = "si3mshady-${random_id.rid[count.index].dec}"
    }
    
    key_name = aws_key_pair.si3mshadykp.id
    vpc_security_group_ids = [var.public_sg]
    subnet_id = var.public_subnets[count.index]
    user_data = templatefile(var.user_data_path,
    {
        nodename = "si3mshady-${random_id.rid[count.index].dec}"
       
    }
    
    )
    root_block_device {
    volume_size = var.vol_size
  }
  
   provisioner "remote-exec" {
       connection {
           type="ssh"
           user="ubuntu"
           host=self.public_ip
           private_key=file("/home/ubuntu/.ssh/id_rsa")
       }
       script = "${path.cwd}/delay.sh"
   }
  
  provisioner "local-exec" {
      command = templatefile("${path.cwd}/scp_script.tpl",
      {
          nodeip = self.public_ip
          k3s_path = "${path.cwd}/../"
          nodename = self.tags.Name
      }
      )
  }
    
}