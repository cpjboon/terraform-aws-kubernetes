variable "vpc_cidr" {
  description = "The VPC main CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "home_ip" {
  description = "The static IP address of my ISP, or 0.0.0.0/0, will be used in the security group ssh"
  type        = string
  default     = "0.0.0.0/0"
}

variable "worker_count" {
  description = "Number of worker instances to provision"
  type        = number
  default     = 3
}

variable "subnet_primary_cidr" {
  description = "Subnet Availability Zone A CIDR" 
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_secondary_cidr" {
  description = "Subnet Availability Zone B CIDR" 
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet_tertiary_cidr" {
  description = "Subnet Availability Zone C CIDR" 
  type        = string
  default     = "10.0.3.0/24"
}

variable "master_size" {
  description = "the instance size of the master node"
  type        = string
  default     = "t3.small"
}

variable "worker_size" {
  description = "the instance size of the worker node"
  type        = string
  default     = "t3.small"
}

variable "deployer_key" {
  description = "the ssh public key to connect to the ec2 servers"
  type        = string
}
