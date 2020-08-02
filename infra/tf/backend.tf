terraform {
  backend "s3" {
    bucket  = "turbo-remote-backend"
    key     = "turbo-v1"
    region  = "us-east-1"
    profile = "terraform-remote-backend"
  }
}
