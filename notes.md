Todo
1. MSI must have permissions to access the SA

az account set --subscription "355f69b4-9fad-45c6-b881-2e7a4d376b18"
terraform plan -var-file="parameters/dev.tfvars"
terraform init -backend-config ="parameters/backend_dev.hcl"
terraform init -backend-config=parameters/backend_dev.hc

terraform init -reconfigure -backend-config="backend_configs/dev.azurerm.tfbackend"
terraform plan -var-file="parameters/dev.tfvars" -auto-approve
terraform apply -var-file="parameters/dev.tfvars" -auto-approve
terraform destroy -var-file="parameters/dev.tfvars" -auto-approve

terraform init -reconfigure -backend-config="backend_configs/test.conf" 
terraform apply -var-file="parameters/test.tfvars"

