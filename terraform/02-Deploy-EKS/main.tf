
provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

locals {
  cluster_name = "${var.hostname}"
  cluster_region = "us-east-1"
}


variable "hostname" {
  type = string
  # Optionally, you can provide a default value if the environment variable isn't set
  default = "hostnameNotSet"
}


