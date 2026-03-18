#!/bin/bash
# audit_infra.sh v2.2 - Auditoría de Persistencia Robusta

GREEN='\033[0-32m'
BLUE='\033[0-34m'
RED='\033[0-31m'
NC='\033[0m'

echo -e "${GREEN}=== MONITOR DE GOBERNANZA FINOPS ===${NC}"

# 1. Backend (AWS) - Validación Profunda
echo -e "\n${BLUE}[1/4] Capa de Persistencia (AWS):${NC}"
AWS_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null)
aws s3 ls "s3://finops-tfstate-$AWS_ID" > /dev/null 2>&1 && echo "✅ S3 Bucket: Detectado" || echo -e "${RED}❌ S3 Bucket: Ausente${NC}"

# Verificación de DynamoDB sin filtros restrictivos
DYNAMO_STATUS=$(aws dynamodb describe-table --table-name tf-state-lock --query "Table.TableStatus" --output text 2>/dev/null)
if [ -z "$DYNAMO_STATUS" ]; then
    echo -e "${RED}❌ DynamoDB Lock: No encontrado o sin permisos${NC}"
else
    echo -e "✅ DynamoDB Lock: Detectado (Estado: $DYNAMO_STATUS)"
fi

# 2. Cómputo AWS (EC2)
echo -e "\n${BLUE}[2/4] Recursos AWS (us-east-1):${NC}"
INSTANCES=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running,pending" --query "Reservations[*].Instances[*].InstanceId" --output text)
if [ -z "$INSTANCES" ]; then echo "✅ No hay instancias activas."; else echo -e "${RED}⚠️ ALERTA: Instancias activas: $INSTANCES${NC}"; fi

# 3. Azure Deep Audit (Resource Groups)
echo -e "\n${BLUE}[3/4] Auditoría de Azure (Resource Groups):${NC}"
RGS=$(az group list --query "[?contains(name, 'finops')].name" --output tsv)
if [ -z "$RGS" ]; then 
    echo "✅ No hay RGs del proyecto."
else
    for rg in $RGS; do
        echo -e "${RED}⚠️ RG DETECTADO: $rg${NC}"
        az resource list --resource-group $rg --query "[].{Name:name, Type:type}" --output table
    done
fi

# 4. Estado de Terraform
echo -e "\n${BLUE}[4/4] Integridad Local:${NC}"
[ -d "terraform/environments/prod/.terraform" ] && echo "✅ Terraform Init: OK" || echo "❌ Terraform Init: PENDIENTE"
