#!/bin/bash
# generate_project.sh - Enterprise Structure Creator

REPO_NAME="cloud-agnostic-finops-framework"
mkdir -p $REPO_NAME/{bootstrap,terraform/{modules,environments/prod},scripts,policies}
cd $REPO_NAME

# Crear .gitignore
cat <<EOF > .gitignore
.terraform/
*.tfstate*
*.exe
*.vars
.env
infracost-report.json
EOF

# Crear Script de Backend (Separado por seguridad)
cat <<EOF > bootstrap/create_backend.sh
#!/bin/bash
# Idempotent AWS S3/DynamoDB Backend Creation
BUCKET_NAME="finops-tfstate-\$(aws sts get-caller-identity --query Account --output text)"
aws s3api create-bucket --bucket \$BUCKET_NAME --region us-east-1 || echo "Bucket exists"
aws s3api put-bucket-versioning --bucket \$BUCKET_NAME --versioning-configuration Status=Enabled
aws dynamodb create-table --table-name tf-state-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 || echo "Table exists"
EOF

chmod 700 bootstrap/create_backend.sh
chmod 600 .gitignore
