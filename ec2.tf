# find most recent ubuntu 20 image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# will set hostnames
data "template_file" "init_worker" {
  count    = var.worker_count
  template = file("scripts/set_hostname.sh")
  vars = {
    var_hostname = "worker${count.index}"
  }
}

data "template_file" "init_master" {
  template = file("scripts/set_hostname.sh")
  vars = {
    var_hostname = "master0"
  }
}

# existing public key to be able to ssh to the instances
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.deployer_key
}

# a resource to create random subnets
resource "random_shuffle" "az" {
  input        = [aws_subnet.primary.id, aws_subnet.secondary.id, aws_subnet.tertiary.id]
  result_count = 3
}

resource "aws_instance" "master" {
  ami                         = data.aws_ami.ubuntu.id
  count                       = 1
  instance_type               = var.master_size
  key_name                    = aws_key_pair.deployer.id 
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id, aws_security_group.allow_internal_traffic.id]
  associate_public_ip_address = true
  subnet_id                   = "${element(random_shuffle.az.result, count.index)}"
 
  user_data                   = data.template_file.init_master.rendered
 
  tags = {
    Name = "master"
  }
}

resource "aws_instance" "workers" {
  ami                         = data.aws_ami.ubuntu.id
  count                       = var.worker_count
  instance_type               = var.worker_size
  key_name                    = aws_key_pair.deployer.id 
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id, aws_security_group.allow_internal_traffic.id]
  associate_public_ip_address = true
  #subnet_id                  = aws_subnet.secondary.id
  subnet_id                   = "${element(random_shuffle.az.result, count.index)}"

  user_data                   = data.template_file.init_worker[count.index].rendered

  tags = {
    Name = "worker-${count.index}"
  }
}
