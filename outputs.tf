output "arn" {
  value       = aws_glue_job.default.arn
  description = "ARN of the Glue job"
}

output "id" {
  value       = aws_glue_job.default.id
  description = "The Glue job name"
}
