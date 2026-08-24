output "instance_id" {
  description = "Monitoring EC2 instance ID"
  value       = aws_instance.monitoring.id
}

output "public_ip" {
  description = "Stable Elastic IP address"
  value       = aws_eip.monitoring.public_ip
}

output "grafana_url" {
  description = "Grafana URL"
  value       = "http://${aws_eip.monitoring.public_ip}:3000"
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = "http://${aws_eip.monitoring.public_ip}:9090"
}

output "node_exporter_url" {
  description = "Node Exporter URL"
  value       = "http://${aws_eip.monitoring.public_ip}:9100/metrics"
}

output "elastic_ip_id" {
  description = "Elastic IP allocation ID"
  value       = aws_eip.monitoring.id
}
