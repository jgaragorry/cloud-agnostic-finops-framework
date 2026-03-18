#!/bin/bash
# destroy_backend.sh v2.0 - Destrucción con Seguridad y Confirmación

RED='\033[0-31m'
YELLOW='\033[1-33m'
GREEN='\033[0-32m'
NC='\033[0m'

echo -e "${RED}⚠️  ¡ADVERTENCIA DE SEGURIDAD CRÍTICA! ⚠️${NC}"
echo -e "${YELLOW}Estás a punto de eliminar la Capa de Persistencia (Backend).${NC}"
echo -e "Esto borrará el historial de Terraform y la tabla de bloqueo."
echo -e "Si existen recursos desplegados, perderás la trazabilidad y podrías generar costos ocultos.\n"

# 1. Petición de confirmación (Safe Check)
read -p "Escribe la palabra 'ELIMINAR' para confirmar la destrucción total: " CONFIRM

if [[ "$CONFIRM" != "ELIMINAR" ]]; then
    echo -e "${GREEN}❌ Operación cancelada. El backend sigue a salvo.${NC}"
    exit 1
fi

echo -e "\n${RED}🚀 Procediendo con la destrucción quirúrgica...${NC}"

AWS_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null)
BUCKET_NAME="finops-tfstate-$AWS_ID"
TABLE_NAME="tf-state-lock"

# 2. Vaciado profundo de S3 (Manejando versiones y marcadores)
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "📦 Limpiando versiones de objetos en $BUCKET_NAME..."
    # Eliminar versiones y marcadores de borrado
    aws s3api delete-objects --bucket "$BUCKET_NAME"         --delete "$(aws s3api list-object-versions --bucket "$BUCKET_NAME" --output json --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}')" > /dev/null 2>&1
    aws s3api delete-objects --bucket "$BUCKET_NAME"         --delete "$(aws s3api list-object-versions --bucket "$BUCKET_NAME" --output json --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}')" > /dev/null 2>&1
    
    aws s3 rb "s3://$BUCKET_NAME" --force
    echo -e "${GREEN}✅ Bucket eliminado.${NC}"
fi

# 3. Eliminación de DynamoDB
if aws dynamodb describe-table --table-name "$TABLE_NAME" > /dev/null 2>&1; then
    echo "🔐 Eliminando tabla $TABLE_NAME..."
    aws dynamodb delete-table --table-name "$TABLE_NAME" > /dev/null
    aws dynamodb wait table-not-exists --table-name "$TABLE_NAME"
    echo -e "${GREEN}✅ Tabla DynamoDB eliminada.${NC}"
fi

echo -e "\n${GREEN}--- NUBE LIMPIA Y TRAZABILIDAD CERRADA ---${NC}"
