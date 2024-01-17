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
## Setup a cluster

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
....

ansible-playbook -i inventory-eu-west-1 install_cluster.yml
```
