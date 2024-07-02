variable "aws_region" {
  description = "The Name of the region"
  type        = string
}

variable "route53_zone_id" {
  description = "The ID of the Route 53 hosted zone"
  type        = string
}

# variable in workflow file should be assigned here.
variable "dockerhub_username" {
  description = "Docker Hub Username"
  type        = string
}

variable "dockerhub_password" {
  description = "Docker Hub Password"
  type        = string
  sensitive   = true
}