# 📖 Runbook: Operación Multi-Cloud FinOps

> **Guía de Ejecución Quirúrgica para el Despliegue y Desmantelamiento de Infraestructura.**

<div align="center">

[![Fase 1](https://img.shields.io/badge/Fase_1-Bootstrap-623CE4?style=for-the-badge&logo=hashicorp&logoColor=white)]()
[![Fase 2](https://img.shields.io/badge/Fase_2-FinOps_Audit-00D084?style=for-the-badge&logo=infracost&logoColor=white)]()
[![Fase 3](https://img.shields.io/badge/Fase_3-Deploy-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)]()
[![Fase 4](https://img.shields.io/badge/Fase_4-Forensic-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)]()
[![Fase 5](https://img.shields.io/badge/Fase_5-Tabula_Rasa-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)]()

</div>

> [!IMPORTANT]
> Este documento es la **única fuente de verdad** para operar el framework.
> Sigue el orden de fases **estrictamente** para garantizar la integridad del Remote State y la Gobernanza Financiera.

---

## 📌 Tabla de Contenido

- [🔄 Visión General del Pipeline](#-visión-general-del-pipeline)
- [🛠️ Fase 1 — Bootstrap](#%EF%B8%8F-fase-1-preparación-del-entorno-bootstrap)
- [💰 Fase 2 — FinOps Audit](#-fase-2-auditoría-finops-shift-left)
- [⚙️ Fase 3 — Deploy](#%EF%B8%8F-fase-3-despliegue-multicloud-execution)
- [🔍 Fase 4 — Forensic Audit](#-fase-4-auditoría-forense-post-deploy)
- [🗑️ Fase 5 — Tabula Rasa](#%EF%B8%8F-fase-5-desmantelamiento-seguro-tabula-rasa)
- [🚩 Troubleshooting](#-solución-de-problemas-troubleshooting)

---

## 🔄 Visión General del Pipeline

```mermaid
flowchart LR
    A("🚀 START") --> B["🛠️ Fase 1\nBootstrap\nBackend Remoto"]
    B --> C["💰 Fase 2\nFinOps Audit\nShift-Left"]
    C --> D["⚙️ Fase 3\nDeploy\nMulticloud"]
    D --> E["🔍 Fase 4\nForensic\nAudit"]
    E --> F["🗑️ Fase 5\nTabula Rasa\nDestroy"]
    F --> G("✅ NUBE\nLIMPIA")

    style A fill:#00D084,color:#fff,stroke:none
    style B fill:#623CE4,color:#fff,stroke:none
    style C fill:#00D084,color:#fff,stroke:none
    style D fill:#232F3E,color:#fff,stroke:none
    style E fill:#0089D6,color:#fff,stroke:none
    style F fill:#E95420,color:#fff,stroke:none
    style G fill:#00D084,color:#fff,stroke:none
```

---

## 🛠️ Fase 1: Preparación del Entorno (Bootstrap)

![Bootstrap](https://img.shields.io/badge/Objetivo-Capa_de_Persistencia-623CE4?style=flat-square&logo=hashicorp&logoColor=white)

**Propósito:** Establecer la "Capa de Persistencia" en la nube. Sin esta fase, Terraform no tendría dónde guardar su memoria (Estado) de forma segura.

```mermaid
graph LR
    A["👨‍💻 Usuario"] --> B["scripts/create_backend.sh"]
    B --> C[("☁️ AWS S3\nRemote State")]
    B --> D["🔒 AWS DynamoDB\nState Lock"]

    style A fill:#1a1a2e,color:#fff,stroke:#623CE4
    style B fill:#623CE4,color:#fff,stroke:none
    style C fill:#00D084,color:#fff,stroke:none
    style D fill:#00D084,color:#fff,stroke:none
```

### Pasos de Ejecución

**1.** Abrir la terminal en la raíz del proyecto:
```bash
cd cloud-agnostic-finops-framework
```

**2.** Otorgar permisos de ejecución a los scripts:
```bash
chmod +x scripts/*.sh
```

**3.** Ejecutar el provisionamiento del Backend:
```bash
./scripts/create_backend.sh
```

> [!NOTE]
> **¿Por qué este paso?** Creamos un bucket S3 único usando tu **Account ID de AWS** y una tabla DynamoDB. Esto evita que dos procesos modifiquen el estado de la nube simultáneamente *(State Locking)*.

---

## 💰 Fase 2: Auditoría FinOps (Shift-Left)

![FinOps](https://img.shields.io/badge/Objetivo-Visibilidad_Financiera_Preventiva-00D084?style=flat-square&logo=infracost&logoColor=white)

**Propósito:** Saber cuánto costará la infraestructura **antes de que exista**. Es el pilar de la responsabilidad financiera.

```mermaid
graph LR
    A["📄 Terraform Code"] --> B["💰 Infracost CLI"]
    B --> C{"📊 Reporte\nde Costos"}
    C -->|"✅ $0.00 Free Tier"| D["🚀 Aprobar\nDespliegue"]
    C -->|"⚠️ Costo Alto"| E["🔄 Revisar\nCódigo"]

    style B fill:#00D084,color:#fff,stroke:none
    style D fill:#232F3E,color:#fff,stroke:none
    style E fill:#E95420,color:#fff,stroke:none
```

### Pasos de Ejecución

**1.** Configurar la API Key *(solo la primera vez)*:
```bash
infracost configure set api_key TU_CLI_TOKEN_AQUI
```

**2.** Generar el desglose de costos:
```bash
infracost breakdown --path terraform/environments/prod
```

> [!TIP]
> **Validación:** El reporte puede mostrar nominalmente ~`$8 USD`, pero el costo real en la factura de AWS es **`$0.00`** gracias al Free Tier. Verifica que los recursos sean `t3.micro`, `S3 Standard` y `DynamoDB on-demand`.

---

## ⚙️ Fase 3: Despliegue Multicloud (Execution)

![Deploy](https://img.shields.io/badge/Objetivo-Infraestructura_Viva_en_AWS_&_Azure-232F3E?style=flat-square&logo=terraform&logoColor=white)

**Propósito:** Transformar el código HCL en recursos reales en AWS y Azure de forma **atómica**.

```mermaid
sequenceDiagram
    autonumber
    participant TF as ⚙️ Terraform
    participant S3 as 🗄️ S3 Backend
    participant AWS as ☁️ AWS Cloud
    participant AZ as 🟦 Azure Cloud

    TF->>S3: terraform init — Sincronizar Backend
    TF->>S3: Adquirir State Lock 🔐
    TF->>AWS: Crear EC2 (t3.micro)
    TF->>AZ: Crear Resource Group
    S3-->>TF: Persistir nuevo Estado
    TF->>S3: Liberar State Lock 🔓
    Note over TF,AZ: ✅ Infraestructura Viva
```

### Pasos de Ejecución

**1.** Entrar al directorio de producción:
```bash
cd terraform/environments/prod
```

**2.** Inicializar Terraform y conectar al Backend remoto:
```bash
terraform init
```

**3.** Planificar y guardar el plan auditado:
```bash
terraform plan -out=finops.tfplan
```

**4.** Aplicar el plan:
```bash
terraform apply "finops.tfplan"
```

> [!NOTE]
> Usar `-out=finops.tfplan` garantiza que lo que se **planificó** es exactamente lo que se **aplica**. Nunca ejecutes `terraform apply` sin un plan previo en entornos de producción.

---

## 🔍 Fase 4: Auditoría Forense (Post-Deploy)

![Forensic](https://img.shields.io/badge/Objetivo-Validación_Real_vs_Diseño-0089D6?style=flat-square&logo=microsoft-azure&logoColor=white)

**Propósito:** Validar que la **realidad de la nube** coincide con lo que el arquitecto diseñó. Sin este paso, el despliegue no está verificado.

```mermaid
graph TD
    A["🔍 audit_infra.sh"] --> B{"¿EC2 encendida?\n(AWS)"}
    A --> C{"¿Resource Group\ncreado? (Azure)"}
    A --> D{"¿Backend S3\nactivo?"}
    B -->|"✅ Detectado"| E(["✅ Verificación\nExitosa"])
    C -->|"✅ Detectado"| E
    D -->|"✅ Detectado"| E
    B -->|"❌ Ausente"| F(["🚨 Alerta\nInvestigar"])
    C -->|"❌ Ausente"| F
    D -->|"❌ Ausente"| F

    style E fill:#00D084,color:#fff,stroke:none
    style F fill:#E95420,color:#fff,stroke:none
    style A fill:#0089D6,color:#fff,stroke:none
```

### Pasos de Ejecución

**1.** Regresar a la raíz del proyecto:
```bash
cd ../../../
```

**2.** Ejecutar el auditor forense:
```bash
./scripts/audit_infra.sh
```

> [!IMPORTANT]
> **Validación:** Todos los checks deben aparecer en **Verde** `(Detectado/OK)`. Si alguno falla, **no continúes** a la Fase 5 hasta investigar la causa.

---

## 🗑️ Fase 5: Desmantelamiento Seguro (Tabula Rasa)

![Destroy](https://img.shields.io/badge/Objetivo-Zero--Waste_&_$0.00_Final-E95420?style=flat-square&logo=ubuntu&logoColor=white)

**Propósito:** Eliminar cada rastro de la infraestructura para garantizar el **Zero-Waste** y evitar cargos accidentales.

```mermaid
flowchart LR
    A["⚙️ terraform destroy\n-auto-approve"] --> B["🔴 Terminar\nEC2 AWS"]
    A --> C["🟦 Eliminar\nRG Azure"]
    B & C --> D["🗑️ destroy_backend.sh"]
    D --> E["🔴 Borrar\nS3 Bucket"]
    D --> F["🔴 Borrar\nDynamoDB Table"]
    E & F --> G(["🏁 Nube Limpia\n$0.00 USD"])

    style A fill:#E95420,color:#fff,stroke:none
    style D fill:#E95420,color:#fff,stroke:none
    style G fill:#00D084,color:#fff,stroke:none
```

### Pasos de Ejecución *(Orden Crítico)*

**1.** Destruir los recursos gestionados por Terraform:
```bash
cd terraform/environments/prod
terraform destroy -auto-approve
```

**2.** Destruir la Capa de Persistencia *(regresar a la raíz primero)*:
```bash
cd ../../../
./scripts/destroy_backend.sh
```

**3.** Validación Final — Confirmar estado limpio:
```bash
./scripts/audit_infra.sh
# ✅ Todo debe aparecer como: Ausente
```

> [!WARNING]
> **Nota de Seguridad:** El script `destroy_backend.sh` te pedirá escribir `ELIMINAR` para confirmar. Este paso es **irreversible** y borra toda la trazabilidad del estado remoto. Procede con absoluta certeza.

---

## 🚩 Solución de Problemas (Troubleshooting)

| # | Error Común | Causa | Solución |
|:---:|:---|:---|:---|
| 1 | `InvalidAMIID.NotFound` | La imagen de Ubuntu cambió en la región. | El código usa **Data Sources dinámicos**; solo corre `terraform plan` de nuevo. |
| 2 | `AccessDenied` | Credenciales expiradas o sin permisos. | Ejecuta `aws configure` o `az login` para refrescar los tokens. |
| 3 | `BucketAlreadyExists` | El nombre del bucket ya está tomado globalmente. | El script usa el **Account ID de AWS**, lo que garantiza unicidad global. Si persiste, verifica la región. |
| 4 | `StateLockError` | Proceso anterior no liberó el lock. | Ejecuta `terraform force-unlock <LOCK_ID>` con precaución. |
| 5 | `ResourceGroupNotFound` | Azure CLI no autenticado. | Ejecuta `az login` y verifica la suscripción activa con `az account show`. |

---

<div align="center">

---

*Firmado por:*
**Arquitectura de Soluciones — Framework FinOps Multicloud**

![Zero Waste](https://img.shields.io/badge/Policy-Zero--Waste_Cloud-00D084?style=flat-square&logo=leaf&logoColor=white)
![Multicloud](https://img.shields.io/badge/Strategy-Multi--Cloud_FinOps-623CE4?style=flat-square&logo=terraform&logoColor=white)
![Free Tier](https://img.shields.io/badge/Cost-$0.00_Verified-success?style=flat-square)

</div>

