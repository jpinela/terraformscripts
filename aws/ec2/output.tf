output "s3_bucket_name" {
  value = aws_s3_bucket.emrbucket.id
}

output "emr_cluster_id" {
  value = aws_emr_cluster.emr_cluster.id
}

output "emr_role_arn" {
  value = aws_iam_role.emr_role.arn
}
