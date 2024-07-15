variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "The name of the EMR cluster."
  default     = "emr-10"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket."
  default     = "emr-10-01-ecu32"
}

variable "emr_role_name" {
  description = "The name of the IAM role."
  default     = "emr-10-role"
}

variable "number_of_nodes" {
  description = "The number of nodes in the EMR cluster core."
  default     = 1
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the EMR cluster in."
  default ="subnet_null"
}


