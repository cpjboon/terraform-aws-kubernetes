# terraform-aws-kubernetes

## _Install terraform Kubernetes cluster on Amazon_

## Dependencies
- terraform binary (https://developer.hashicorp.com/terraform/install)
- ansible 
- aws cli

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
terraform workspace create eu-west-1
terraform plan
terraform apply
ansible-playbook -i inventory-eu-west-1 install_cluster.yml
```
