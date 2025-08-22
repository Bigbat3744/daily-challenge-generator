variable "region" {
  description = "AWS region to deploy resources"
  default     = "eu-west-2"
}
variable "bucket_name" {
  description = "Name of the S3 bucket for frontend hosting"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-2"  # London region
}

