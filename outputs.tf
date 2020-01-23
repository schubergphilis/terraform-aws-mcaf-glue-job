output "arn" {
  value       = aws_glue_job.default.arn
  description = "ARN of the glue job"
}

output "id" {
  value       = aws_glue_job.default.id
  description = "The glue job name"
}
