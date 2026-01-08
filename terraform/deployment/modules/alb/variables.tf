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
