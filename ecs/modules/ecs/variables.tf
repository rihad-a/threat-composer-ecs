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

variable "tg_arn" {
  type        = string
  description = "The target group arn from the alb module"
}

variable "subnetpri1_id" {
  type        = string
  description = "The private 1 subnet id from the vpc module"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id from the vpc module"
}

