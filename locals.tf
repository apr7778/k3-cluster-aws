locals {
  ami          = "ami-0ae8f15ae66fe8cda"  # Replace with your actual AMI ID
  instancetype = "t3a.medium"               # Replace with your desired instance type
  key_name      = "pem key not extension"          # Replace with your actual key name
  k3s_master_sec_group_id = aws_security_group.k3s-master-sec-group.id
  k3s_worker_sec_group_id = aws_security_group.k3s-worker-sec-group.id
}