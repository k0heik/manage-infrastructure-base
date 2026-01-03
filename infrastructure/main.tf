resource "aws_s3_bucket" "main" {
  bucket = "${local.system}-135698-${var.environment}"
}
