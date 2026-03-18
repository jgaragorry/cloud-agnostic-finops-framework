# 🏛️ Cloud-Agnostic FinOps & Governance Framework

> **Architecting Resilient Multi-Cloud Solutions with Zero-Waste Lifecycle Management.**

<div align="center">

[![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Infracost](https://img.shields.io/badge/FinOps-Infracost-00D084?style=for-the-badge&logo=infracost&logoColor=white)](https://www.infracost.io/)
[![AWS](https://img.shields.io/badge/AWS-Solutions_Arch-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Azure](https://img.shields.io/badge/Azure-Governance-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04_LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Cost](https://img.shields.io/badge/Cloud_Cost-$0.00_USD-00D084?style=for-the-badge&logo=dollar-sign&logoColor=white)]()
[![IaC](https://img.shields.io/badge/IaC-100%25_Declarative-623CE4?style=for-the-badge&logo=hashicorp&logoColor=white)]()

</div>

---

## 📌 Tabla de Contenido

- [🎤 Arquitectura en 10 Segundos](#-arquitectura-en-10-segundos)
- [🗺️ Diagrama de Alcance](#%EF%B8%8F-diagrama-de-alcance-solución-multicloud)
- [🔄 Ciclo de Vida del Estado](#-ciclo-de-vida-del-estado-terraform)
- [🛠️ Decisiones de Arquitectura](#%EF%B8%8F-ficha-técnica-decisiones-de-arquitectura)
- [📊 Matriz de Costos FinOps](#-matriz-de-costos-nube-limpia)
- [📖 Runbook Quirúrgico](#-runbook-quirúrgico-lifecycle)
- [📁 Estructura del Proyecto](#-estructura-del-proyecto)
- [🚀 Quickstart](#-quickstart)
- [📬 Contacto](#-contacto--estrategia-profesional)

---

## 🎤 Arquitectura en 10 Segundos

> *"En este laboratorio no solo desplegamos recursos; implementamos **Gobernanza Multicloud con enfoque FinOps**. He diseñado una arquitectura agnóstica capaz de orquestar **AWS y Azure** simultáneamente, garantizando la integridad del estado mediante **State Locking** y prediciendo el impacto financiero con **Shift-Left Cost Analysis** antes de tocar la nube. Esto es infraestructura real, diseñada para el mundo real."*

---

## 🗺️ Diagrama de Alcance (Solución Multicloud)

```mermaid
graph TD
    classDef cloud fill:#f9f,stroke:#333,stroke-width:2px,color:#000
    classDef storage fill:#00d084,stroke:#333,stroke-width:2px,color:#fff
    classDef compute fill:#623ce4,stroke:#333,stroke-width:2px,color:#fff
    classDef tool fill:#e95420,stroke:#333,stroke-width:1px,color:#fff

    subgraph WS["🖥️ Workstation — Ubuntu 24.04 LTS"]
        A[⚙️ Terraform Core]:::tool -->|"1️⃣ Cost Audit"| B["💰 Infracost CLI"]:::tool
        A -->|"4️⃣ Forensic Audit"| C{"🔍 Audit Script"}:::tool
    end

    subgraph AWS["☁️ AWS Global Infrastructure — Control Plane"]
        D[("🗄️ S3: Remote State")]:::storage --- E["🔒 DynamoDB: State Lock"]:::storage
        D -.->|"2️⃣ Persist State"| A
    end

    subgraph MC["🌐 Multi-Cloud Execution Layer"]
        A -->|"3️⃣ Deploy"| G["🖥️ AWS: EC2 t3.micro"]:::compute
        A -->|"3️⃣ Orchestrate"| H["🟦 Azure: Resource Group"]:::compute
    end

    G --- C
    H --- C
```

---

## 🔄 Ciclo de Vida del Estado (Terraform)

```mermaid
sequenceDiagram
    autonumber
    actor Dev as 👨‍💻 Engineer
    participant IC as 💰 Infracost
    participant TF as ⚙️ Terraform
    participant S3 as 🗄️ S3 Backend
    participant DDB as 🔒 DynamoDB Lock
    participant AWS as ☁️ AWS (EC2)
    participant AZ as 🟦 Azure (RG)

    Dev->>IC: infracost breakdown --path .
    IC-->>Dev: 📊 Cost Report ($0.00 — Free Tier)
    Dev->>TF: terraform init
    TF->>S3: Pull Remote State
    TF->>DDB: Acquire State Lock 🔐
    Dev->>TF: terraform plan -out=finops.tfplan
    Dev->>TF: terraform apply "finops.tfplan"
    TF->>AWS: Deploy EC2 t3.micro
    TF->>AZ: Create Resource Group
    Dev->>TF: ./scripts/audit_infra.sh
    TF-->>Dev: ✅ Forensic Audit OK
    Dev->>TF: terraform destroy
    TF->>AWS: Terminate EC2
    TF->>AZ: Delete Resource Group
    TF->>DDB: Release State Lock 🔓
    TF->>S3: Persist Final State
```

---

## 🛠️ Ficha Técnica: Decisiones de Arquitectura

| Categoría | Tecnología | Justificación Estratégica *(Architect View)* |
|:---:|:---:|:---|
| 🔧 **Orquestación** | Terraform (IaC) | Abstracción declarativa para gestión unificada, reproducible y versionable. |
| 🌐 **Estrategia** | Multi-Cloud | Resiliencia operativa y aprovechamiento de servicios nativos por proveedor. |
| 🔒 **Gobernanza** | Remote Backend (S3 + DynamoDB) | Persistencia cifrada con State Locking para garantizar integridad del dato. |
| 💰 **FinOps** | Infracost | Metodología Shift-Left: auditoría preventiva de costos en fase de diseño. |
| 🔍 **Observabilidad** | Custom Bash Audit | Validación forense inmediata sin latencia de consola web. |
| 🟢 **Capa de Costo** | 100% Free Tier | Arquitectura optimizada para experimentación con costo operativo `$0.00`. |

---

## 📊 Matriz de Costos (Nube Limpia)

| Proveedor | Recurso | Tipo | Costo Estimado | Estado Final |
|:---:|:---|:---:|:---:|:---:|
| ![AWS](https://img.shields.io/badge/-AWS-232F3E?logo=amazon-aws&logoColor=white) | EC2 Instance | `t3.micro` | `$0.00` *(Free Tier)* | 🔴 Destruido |
| ![AWS](https://img.shields.io/badge/-AWS-232F3E?logo=amazon-aws&logoColor=white) | S3 Storage | `Standard` | `$0.00` *(Free Tier)* | 🔴 Destruido |
| ![AWS](https://img.shields.io/badge/-AWS-232F3E?logo=amazon-aws&logoColor=white) | DynamoDB | `WCU/RCU` | `$0.00` *(Free Tier)* | 🔴 Destruido |
| ![Azure](https://img.shields.io/badge/-Azure-0089D6?logo=microsoft-azure&logoColor=white) | Resource Group | `Container` | `$0.00` | 🔴 Destruido |
| | | **TOTAL** | **`$0.00 USD`** | ✅ **Tabula Rasa** |

---

## 📖 Runbook Quirúrgico (Lifecycle)

```mermaid
flowchart LR
    A("🚀 START") --> B["1️⃣ create_backend.sh\n🔒 Capa de Persistencia"]
    B --> C["2️⃣ infracost breakdown\n💰 Shift-Left Cost Analysis"]
    C --> D["3️⃣ terraform init\n+ terraform apply\n⚙️ Orquestación Multicloud"]
    D --> E["4️⃣ audit_infra.sh\n🔍 Validación Forense"]
    E --> F["5️⃣ terraform destroy\n+ destroy_backend.sh\n🗑️ Decommissioning"]
    F --> G("✅ TABULA RASA\n$0.00 USD")

    style A fill:#00D084,color:#fff,stroke:none
    style G fill:#00D084,color:#fff,stroke:none
    style B fill:#623CE4,color:#fff,stroke:none
    style C fill:#623CE4,color:#fff,stroke:none
    style D fill:#623CE4,color:#fff,stroke:none
    style E fill:#623CE4,color:#fff,stroke:none
    style F fill:#E95420,color:#fff,stroke:none
```

### Comandos por Fase

```bash
# ─────────────────────────────────────────────
# FASE 1 — Gobernanza: Capa de Persistencia
# ─────────────────────────────────────────────
chmod +x scripts/create_backend.sh
./scripts/create_backend.sh

# ─────────────────────────────────────────────
# FASE 2 — FinOps: Shift-Left Cost Breakdown
# ─────────────────────────────────────────────
infracost breakdown --path terraform/environments/prod

# ─────────────────────────────────────────────
# FASE 3 — Orquestación: Despliegue Multicloud
# ─────────────────────────────────────────────
cd terraform/environments/prod
terraform init
terraform plan -out=finops.tfplan
terraform apply "finops.tfplan"

# ─────────────────────────────────────────────
# FASE 4 — Observabilidad: Auditoría Forense
# ─────────────────────────────────────────────
./scripts/audit_infra.sh

# ─────────────────────────────────────────────
# FASE 5 — Decommissioning: Safety Guardrail
# ─────────────────────────────────────────────
terraform destroy
./scripts/destroy_backend.sh
```

---

## 📁 Estructura del Proyecto

```
📦 cloud-agnostic-finops/
├── 📂 terraform/
│   ├── 📂 environments/
│   │   └── 📂 prod/
│   │       ├── main.tf           # Configuración principal
│   │       ├── variables.tf      # Variables de entrada
│   │       ├── outputs.tf        # Outputs del deployment
│   │       └── backend.tf        # Remote State (S3 + DynamoDB)
│   ├── 📂 modules/
│   │   ├── 📂 aws-compute/       # Módulo EC2
│   │   └── 📂 azure-governance/  # Módulo Resource Group
│   └── finops.tfplan             # Plan pre-auditado (Infracost)
├── 📂 scripts/
│   ├── create_backend.sh         # Provisioning del backend remoto
│   ├── destroy_backend.sh        # Decommissioning seguro
│   └── audit_infra.sh            # Validación forense de recursos
├── 📂 docs/
│   └── architecture.md           # Decisiones de diseño (ADR)
├── .infracost/                    # Cache de estimaciones FinOps
├── .gitignore
└── README.md
```

---

## 🚀 Quickstart

### Prerrequisitos

```bash
# Terraform >= 1.5
terraform --version

# Infracost CLI
infracost --version

# AWS CLI configurado
aws configure

# Azure CLI autenticado
az login
```

### Instalación en 5 Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/cloud-agnostic-finops.git
cd cloud-agnostic-finops

# 2. Provisionar backend remoto (S3 + DynamoDB)
./scripts/create_backend.sh

# 3. Auditar costos ANTES de desplegar (Shift-Left FinOps)
infracost breakdown --path terraform/environments/prod

# 4. Inicializar y desplegar infraestructura
cd terraform/environments/prod
terraform init && terraform plan -out=finops.tfplan
terraform apply "finops.tfplan"

# 5. Validar recursos vivos (Forensic Audit)
./scripts/audit_infra.sh
```

---

## 📬 Contacto & Estrategia Profesional

<div align="center">

> *Si buscas escalar infraestructuras con **visibilidad total** y **gobernanza de clase mundial**, hablemos.*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Tu_Nombre-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/tu-usuario)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/tu-usuario)
[![TikTok](https://img.shields.io/badge/TikTok-Cloud_Content-000000?style=for-the-badge&logo=tiktok&logoColor=white)](https://tiktok.com/@tu-usuario)

</div>

---

<div align="center">

**Este proyecto fue diseñado y ejecutado bajo una política de `Zero-Waste`,**
**garantizando una huella financiera neutral.**

![Zero Waste](https://img.shields.io/badge/Policy-Zero--Waste_Cloud-00D084?style=flat-square&logo=leaf&logoColor=white)
![Multicloud](https://img.shields.io/badge/Strategy-Multi--Cloud_FinOps-623CE4?style=flat-square&logo=terraform&logoColor=white)
![Free Tier](https://img.shields.io/badge/Cost-$0.00_Verified-success?style=flat-square)

*Made with 🏛️ Architecture + 💰 FinOps + ☁️ Multi-Cloud*

</div>

