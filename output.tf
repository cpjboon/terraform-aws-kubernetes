resource "local_file" "master_private_ip"  {
  content = "master_private_ip: ${aws_instance.master.0.private_ip}"
  filename = "vars/master_private_ip.yaml"
}
