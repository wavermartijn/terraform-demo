# Output variable definitions

output "id" {
  description = "ARN of the bucket"
  value       = aws_instance.ubuntu-example.id
}
