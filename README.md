# terraform-aws-kubernetes

## _Install terraform Kubernetes cluster on Amazon_

## Dependencies
- terraform binary (https://developer.hashicorp.com/terraform/install)
- ansible 
- aws cli
- a public / private key pair to connect to the ec2 servers (set as default in variables.tf)

Setup your credentials with ~/.aws/credentials

```sh
$ aws configure
AWS Access Key ID [****************23VQ]: 
AWS Secret Access Key [****************js5D]: 
Default region name [eu-west-1]: 
Default output format [None]: 
```

## Clone repository
```sh
$ git clone https://github.com/cpjboon/terraform-aws-kubernetes.git
```

## Create ssh keys or use your own
```sh
$ cd terraform-aws-kubernetes
$ mkdir .ssh
$ ssh-keygen -f .ssh/id_rsa-tf -b4096 -C 'terraform aws deployer key'
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in .ssh/id_rsa-tf
Your public key has been saved in .ssh/id_rsa-tf.pub
The key fingerprint is:
SHA256:C2EBIGh3EuRjeyHs+I2SejiYT2T3YDJA7bmVdOF4Ax0 terraform aws deployer key
The keys randomart image is:
+--[ED25519 256]--+
|o.++oooEo        |
|ooo+ o++         |
|o o*=o=+         |
| .+o++o..        |
| .=o*.. S        |
| oo*+o . .       |
|.=.o .. .        |
|*.o              |
|.+.              |
+----[SHA256]-----+

$ cat .ssh/id_rsa-tf.pub 
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmMiDzBWT7VjNnT4srA3P+ImbUdfPST4CNG8aoyltyY terraform aws deployer key

$ vim terraform.tfvars
deployer_key = ""ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmMiDzBWT7VjNnT4srA3P+ImbUdfPST4CNG8aoyltyY terraform aws deployer key"
```
## Create EC2 instances
```sh
$ terraform workspace new eu-west-1
Created and switched to workspace "eu-west-1"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.

$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Finding latest version of hashicorp/random...
- Finding latest version of hashicorp/local...
- Finding latest version of hashicorp/template...
- Installing hashicorp/aws v5.32.1...
- Installed hashicorp/aws v5.32.1 (signed by HashiCorp)
- Installing hashicorp/random v3.6.0...
- Installed hashicorp/random v3.6.0 (signed by HashiCorp)
- Installing hashicorp/local v2.4.1...
- Installed hashicorp/local v2.4.1 (signed by HashiCorp)
- Installing hashicorp/template v2.2.0...
- Installed hashicorp/template v2.2.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.


$ terraform plan
...

$ terraform apply
...
```

## Configure Kubernetes cluster with Ansible
In this example, eu-west-1 is used so an inventory file inventory-eu-west-1 is created.
To deploy the cluster:
```sh
ansible-playbook -i inventory-eu-west-1 install_cluster.yaml
...
TASK [show master ip] ********************************************************************************************************************************************************************************************************************************************************
ok: [34.249.145.169] => {
    "msg": "To connect to the master node: ssh -i .ssh/id_rsa-tf ubuntu@34.249.145.169"
}
```
You will see the command to connect to the master node.
```sh
$ ssh -i .ssh/id_rsa-tf ubuntu@34.249.145.169
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1051-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Jan 17 16:58:30 UTC 2024

  System load:  0.21              Processes:                146
  Usage of /:   62.6% of 7.57GB   Users logged in:          0
  Memory usage: 45%               IPv4 address for docker0: 172.17.0.1
  Swap usage:   0%                IPv4 address for ens5:    10.0.2.228


Expanded Security Maintenance for Applications is not enabled.

20 updates can be applied immediately.
13 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

New release '22.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Wed Jan 17 16:57:07 2024 from 84.105.22.173
```

## View cluster
```sh
ubuntu@master0:~$ sudo -i
root@master0:~# k get nodes
NAME      STATUS   ROLES           AGE     VERSION
master0   Ready    control-plane   3m47s   v1.28.2
worker0   Ready    <none>          104s    v1.28.2
worker1   Ready    <none>          100s    v1.28.2
worker2   Ready    <none>          96s     v1.28.2
```

