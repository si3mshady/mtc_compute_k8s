# -- root/networking/main.tf

module "networking" {
  source            = "./networking"
  vpc_cidr          = local.vpc_cidr
  access_ip         = var.access_ip
  security_groups   = local.security_groups
  pub_subnet_count  = 4
  priv_subnet_count = 3
  max_subnets       = 20
  public_cidrs      = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs     = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]


  }
  

module "compute" {
  source = "./compute"
  public_sg = module.networking.public_sg
  public_subnets =  module.networking.public_subnets
  instance_count = 3
  key_name = "si3mshadykp"
  public_key_path = "/home/ubuntu/.ssh/id_rsa.pub"
  instance_type = "t2.2xlarge"
  vol_size = 60 
  user_data_path = "${path.root}/userdata.tpl"
}

 