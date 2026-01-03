terraform {
  required_version = ">= 1.14.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.25.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0"
    }
  }
  backend "s3" {
    region = "ap-northeast-1"
  }
}
