# --- General ---

variable "domain_name" {
  type        = string
  description = "The domain name for the infrastructure"
}

# --- ALB_TG VARIABLES ---

variable "albtg-port" {
  type        = number
  description = "The port for the target group"
}

# --- ALB ---

variable "alb-port-1" {
  type        = number
  description = "The port for the first listener (HTTPS)"
}

variable "alb-port-2" {
  type        = number
  description = "The port for the second listener (HTTP)"
}

# --- aws vpc ---

variable "vpc-cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "subnet-cidrblock-pub1" {
  type        = string
  description = "The CIDR block for public subnet 1"
}

variable "subnet-cidrblock-pub2" {
  type        = string
  description = "The CIDR block for public subnet 2"
}

variable "subnet-cidrblock-pri1" {
  type        = string
  description = "The CIDR block for private subnet 1"
}

variable "subnet-cidrblock-pri2" {
  type        = string
  description = "The CIDR block for private subnet 2"
}

variable "subnet-az-2a" {
  type        = string
  description = "Availability zone for the 'a' subnets"
}

variable "subnet-az-2b" {
  type        = string
  description = "Availability zone for the 'b' subnets"
}

variable "routetable-cidr" {
  type        = string
  description = "Destination CIDR for the route table"
}

variable "subnet-map_public_ip_on_launch_public" {
  type        = bool
  description = "Boolean to map public IP on launch for public subnets"
}

variable "subnet-map_public_ip_on_launch_private" {
  type        = bool
  description = "Boolean to map public IP on launch for private subnets"
}

# --- ecs creation ---

variable "ecs-container-name" {
  type        = string
  description = "The name of the container in the task definition"
}

variable "ecs-containerport" {
  type        = number
  description = "The port the container listens on"
}

variable "ecstg-port" {
  type        = number
  description = "The port for the target group"
}

variable "ecs-port-1" {
  type        = number
  description = "The port for the first listener (HTTPS)"
}

variable "ecs-port-2" {
  type        = number
  description = "The port for the second listener (HTTP)"
}

# module variables

variable "vpc_id" {
  type        = string
  description = "The VPC id from the vpc module"
}

variable "subnetpub1_id" {
  type        = string
  description = "The public 1 subnet id from the vpc module"
}

variable "subnetpub2_id" {
  type        = string
  description = "The public 2 subnet id from the vpc module"
}

variable "certificate_arn" {
  type        = string
  description = "The certificate arn from the route53 module"
}
