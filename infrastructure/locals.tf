locals {
  system = "manage-infrastructure-base"
  default_tags = {
    Environment = var.environment
    System      = local.system
  }
}
