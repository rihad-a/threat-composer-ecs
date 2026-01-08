# --- General ---
domain_name                              = "networking.rihad.co.uk"

# --- ALB_TG VARIABLES ---
albtg-port                               = 3000

# --- ALB ---
alb-port-1                               = 443
alb-port-2                               = 80

# --- aws vpc ---
vpc-cidr                                 = "10.0.0.0/16"
subnet-cidrblock-pub1                    = "10.0.101.0/24"
subnet-cidrblock-pub2                    = "10.0.102.0/24"
subnet-cidrblock-pri1                    = "10.0.1.0/24"
subnet-cidrblock-pri2                    = "10.0.2.0/24"
subnet-az-2a                             = "eu-west-2a"
subnet-az-2b                             = "eu-west-2b"
routetable-cidr                          = "0.0.0.0/0"
subnet-map_public_ip_on_launch_public    = true
subnet-map_public_ip_on_launch_private   = false

# --- ecs creation ---
ecs-container-name                       = "threat-composer"
ecs-containerport                        = 3000
ecstg-port                               = 3000
ecs-port-1                               = 443
ecs-port-2                               = 80