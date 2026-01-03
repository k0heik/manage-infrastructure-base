locals {
  system = "manage-infrastructure-base"
  Environment = var.environment
  default_tags = {
    Environment = var.environment
    System      = local.system
  }
}
