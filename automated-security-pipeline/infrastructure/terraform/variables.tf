variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 5000
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "devsecops-app"
}
