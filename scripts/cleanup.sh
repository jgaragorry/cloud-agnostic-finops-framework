#!/bin/bash
set -e
echo "Iniciando destrucción controlada de infraestructura..."
cd terraform/environments/prod
terraform destroy -auto-approve

echo "Limpiando archivos temporales de Terraform..."
rm -rf .terraform* terraform.tfstate*
