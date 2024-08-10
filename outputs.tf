output "master_node_addr" {
  value = aws_instance.master.private_ip
}

output "workerr_node_addr" {
  value = aws_instance.worker.public_ip
}



