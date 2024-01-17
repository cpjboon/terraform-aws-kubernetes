resource "local_file" "ansible_inventory" {
  content = <<EOF
[master]
%{ for master in aws_instance.master.*.public_ip ~}
${master}
%{ endfor ~}

[worker]
%{ for worker in aws_instance.workers.*.public_ip ~}
${worker}
%{ endfor ~}
  EOF

  filename = "inventory-${terraform.workspace}"
}
