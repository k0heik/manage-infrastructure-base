variable "environment" {
  type        = string
  description = "Environment name (dev/prod)"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be one of: dev, prod."
  }
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-northeast-1"
}
