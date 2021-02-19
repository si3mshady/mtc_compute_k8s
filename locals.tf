locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {

  security_groups = {

    public = {
      name        = "public_sg_dynamic"
      description = "SG for public access created dynamically"
      ingress = {
        open = {
          from        = 0
          to          = 0
          protocol    = -1
          cidr_blocks = [var.access_ip]
        }

        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }

        strayaway = {
          from        = 5000
          to          = 5000
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }
      }
    }
    rds = {
      name        = "rds_sg"
      description = "SG for rds"
      ingress = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]

        }

      }

    }



  }

}