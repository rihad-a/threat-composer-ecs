module "aws_vpc" {
  source = "./modules/vpc"

vpc-cidr                                 = var.vpc-cidr
subnet-cidrblock-pub1                    = var.subnet-cidrblock-pub1
subnet-cidrblock-pub2                    = var.subnet-cidrblock-pub2
subnet-cidrblock-pri1                    = var.subnet-cidrblock-pri1
subnet-cidrblock-pri2                    = var.subnet-cidrblock-pri2
subnet-az-2a                             = var.subnet-az-2a    
subnet-az-2b                             = var.subnet-az-2b    
routetable-cidr                          = var.routetable-cidr     
subnet-map_public_ip_on_launch_public    = var.subnet-map_public_ip_on_launch_public
subnet-map_public_ip_on_launch_private   = var.subnet-map_public_ip_on_launch_private

}

module "alb" {
  source = "./modules/alb"


albtg-port                               = var.albtg-port
alb-port-1                               = var.alb-port-1
alb-port-2                               = var.alb-port-2

  # Use these outputs
  vpc_id            = module.aws_vpc.vpc-id
  subnetpub1_id     = module.aws_vpc.subnet-pub1
  subnetpub2_id     = module.aws_vpc.subnet-pub2
  certificate_arn   = module.route53.certificate_arn
}

module "ecs" {
  source = "./modules/ecs"

ecs-container-name                       = var.ecs-container-name   
ecs-containerport                        = var.ecs-containerport  
ecstg-port                               = var.ecstg-port      
ecs-port-1                               = var.ecs-port-1  
ecs-port-2                               = var.ecs-port-2  

  # Use these outputs
  tg_arn            = module.alb.tg_arn
  subnetpri1_id     = module.aws_vpc.subnet-pri1
  vpc_id            = module.aws_vpc.vpc-id
}

module "route53" {
  source = "./modules/route53"

domain_name                              = var.domain_name

  # Use these outputs
  alb_dns           = module.alb.alb_dns
  alb_zoneid        = module.alb.alb_zoneid
}
