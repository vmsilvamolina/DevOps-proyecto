
# README.md – Proyecto DevOps (StockWiz)

## **🚀 StockWiz – Plataforma de Microservicios con CI/CD, IaC y Observabilidad**

StockWiz es un sistema compuesto por múltiples microservicios construido para demostrar la aplicación completa de prácticas modernas de DevOps en un entorno cloud real sobre AWS. El proyecto integra infraestructura como código, pipelines CI/CD, contenedores Docker, orquestación con ECS Fargate, tests automáticos, análisis de calidad, y principios sólidos de despliegue continuo.

Este repositorio fue diseñado para cumplir con los requerimientos del Obligatorio de DevOps – Agosto 2025 (ORT ATI), mostrando un flujo completo de trabajo desde el desarrollo local hasta el despliegue automatizado en AWS.

# *🎯 Objetivos del Proyecto*

Diseñar e implementar una arquitectura basada en microservicios.

Contenerizar cada servicio mediante Docker.

Construir infraestructura reproducible con Terraform.

Configurar pipelines de CI/CD que automaticen calidad y despliegue.

Monitorear servicios usando CloudWatch.

Mantener buenas prácticas: versionado, seguridad, calidad y automatización.

# *✨ Componentes Principales*

3 microservicios (Go + Python) + API Gateway.

ECS Fargate como plataforma serverless de contenedores.

ECR como repositorio de imágenes.

ALB para exposición del tráfico.

VPC personalizada con subnets públicas/privadas.

SonarCloud para análisis estático.

Tests automáticos con pytest e integración Postman.

GitHub Actions para automatizar construcción, análisis y despliegue.

# *🧩 Flujo General de DevOps*

El desarrollador crea una rama feature → código nuevo.

CI ejecuta análisis Sonar + tests.

Tras aprobación del PR → merge a main.

Pipeline de Terraform despliega o actualiza infraestructura.

ECS toma imágenes nuevas desde ECR y crea un nuevo deployment.

CloudWatch captura logs y métricas en tiempo real.

# *📦 Infraestructura Provisionada Automáticamente*

Red: VPC, subnets, route tables.

Seguridad: Security Groups, IAM roles.

Compute: ECS cluster + servicios + task definitions.

Networking: Application Load Balancer.

Imágenes: Repositorios ECR.

A continuación se detalla la estructura exacta del proyecto:

----------

# 📁 1. Estructura del Proyecto

DevOps-proyecto

├── api-gateway

│ ├── Dockerfile

│ ├── main.go

│ └── static/index.html

│

├── inventory-service

│ ├── Dockerfile

│ ├── main.go

│ └── go.mod / go.sum

│

├── product-service

│ ├── Dockerfile

│ ├── main.py

│ └── requirements.txt

│

├── tests

│ ├── test_postman_collection.json

│ └── test_product_service.py

│

├── infra

│ ├── ecs-task

│ │ ├── task-definition.json

│ │ ├── main.tf

│ └── terraform

│ ├── main.tf

│ ├── dev.tfvars

│ ├── modules/

│ │ ├── vpc

│ │ ├── ecs-cluster

│ │ ├── ecs-service

│ │ ├── ecr

│ │ └── alb

│ ├── variables.tf

│ └── outputs.tf

│

├── docker-compose.yml

└── .github/workflows

├── Terraform-Apply.yml

├── Terraform-destroy.yml

└── main.yml (Tests & Sonar)

----------

# ⚙️ 2. Requisitos Previos

### Herramientas locales

-   Docker
    
-   Terraform 1.13.4
    
-   AWS CLI
    
-   Go
    
-   Python 3.11
    
-   Git
    

### Secrets requeridos en GitHub Actions

Secret

Uso

`AWS_ACCESS_KEY_ID`

Acceso AWS

`AWS_SECRET_ACCESS_KEY`

Acceso AWS

`AWS_SESSION_TOKEN`

STS (opcional)

`AWS_REGION`

Región AWS

`SONAR_PROJECT_KEY`

SonarCloud

`SONAR_ORGANIZATION`

SonarCloud

`SONAR_TOKEN`

SonarCloud

----------

# 🛠️ 3. Ejecución Local

### Levantar todos los servicios

docker-compose up --build

Genera y ejecuta los tres microservicios en red local.

### Build manual de imágenes

docker build -t api-gateway:local ./api-gateway

docker build -t inventory-service:local ./inventory-service

docker build -t product-service:local ./product-service

----------

# 🚢 4. Despliegue Manual con Terraform

### Inicializar Terraform

cd infra/terraform

terraform init

### Seleccionar workspace

terraform workspace select dev || terraform workspace new dev

### Plan + Apply

terraform plan -var-file="dev.tfvars" -out=tfplan

terraform apply -auto-approve tfplan

Esto crea:

-   VPC
    
-   Security Groups
    
-   ALB
    
-   ECS Cluster + ECS Service
    
-   Repositorios ECR
    
-   Roles IAM
    
-   Task Definition
    

----------

# 📦 5. Subida Manual de Imágenes a ECR

### Login

aws ecr get-login-password --region $AWS_REGION | \

docker login --username AWS --password-stdin <ECR_REPO_URI>

### Tag + push

docker tag api-gateway:local <ECR_REPO_URI>/api-gateway:latest

docker push <ECR_REPO_URI>/api-gateway:latest

Repetir para los demás servicios.

----------

# 🤖 6. CI/CD – Pipelines Automáticos (GitHub Actions)

Ubicados en:

.github/workflows/

## ▶️ **1. Terraform-Apply.yml** (Despliegue Infraestructura)

Ejecuta:

-   Checkout
    
-   Setup Terraform
    
-   Credenciales AWS
    
-   Terraform Init
    
-   (Recomendado) Terraform Format & Validate
    
-   Workspace según environment
    
-   Terraform Plan
    
-   Terraform Apply automatico
    

Se ejecuta mediante:

workflow_dispatch → seleccionar environment (dev/staging/prod)

----------

## 🧨 **2. Terraform-destroy.yml** (Elimina Infraestructura)

Solo para ambientes de testing. Ejecuta `terraform destroy -auto-approve` con el .tfvars correspondiente.

----------

## 🧪 **3. main.yml (Test & Sonar)**

Pipeline de calidad. Incluye:

-   Análisis SonarCloud
    
-   Tests del _product-service_ (pytest)
    
-   Preparación Java 17 y Python 3.11
    

Este pipeline actúa como **Quality Gate** antes del despliegue.

----------

# 🌿 7. Estrategia de Ramas (Branching Strategy)

Se implementó **Trunk-Based Development**.

### Ramas principales

-   **main** → Código estable + despliegue automático vía pipeline Terraform Apply
    

### Ramas feature

-   `feature/<nombre>`
    
-   Pequeñas, de corta duración
    
-   Siempre integradas mediante PR
    

### Política de PR

-   Revisión obligatoria
    
-   Tests deben pasar
    
-   SonarCloud debe aprobar Quality Gate
    

### Hotfixes

-   `hotfix/<nombre>` desde `main`
    
-   Merge rápido + despliegue automático
    

**Justificación:**

-   Minimiza conflictos
    
-   Integración continua real
    
-   Reduce tiempo de entrega
    
-   Facilita despliegues automatizados
    

----------

# 🚀 8. Despliegue Automático (CI/CD)

Desde GitHub Actions → `Terraform Deploy` → seleccionar environment:

dev | staging | prod

El pipeline aplica:

-   Infraestructura completa
    
-   Task Definition actualizada
    
-   ECS Service con nueva versión
    

----------

# 🔁 9. Rollback

### Método 1: Cambiar tag en tfvars

image_tag = "tag_anterior"

Luego:

terraform apply -auto-approve

### Método 2: Forzar redeploy del ECS service

aws ecs update-service \

--cluster stockwiz-cluster \

--service stockwiz-service \

--force-new-deployment

----------

# 📊 10. Observabilidad (CloudWatch)

Se recomienda:

-   Logs por contenedor ECS
    
-   Métricas CPU/Memory
    
-   Dashboard con:
    
    -   CPU ECS
        
    -   Memoria
        
    -   Requests
        
    -   Errores 4xx/5xx
        
-   Alarmas:
    
    -   CPU > 80%
        
    -   Error rate > 5%
        

----------

# 🧪 11. Testing

### Tests unitarios / health check

En:

tests/test_product_service.py

Ejecutados automáticamente en `main.yml`.

### Tests Postman

Colección:

tests/test_postman_collection.json

----------

# 🧱 12. Problemas Comunes (Troubleshooting)

Problema

Causa

Solución

ECS task no arranca

Variables faltantes

Revisar CloudWatch Logs

Imagen no encontrada

Push falló

Ver workflow build/push

Terraform lock

Lock en DynamoDB

Quitar lock manual

ALB devuelve 503

Target no pasa healthcheck

Revisar puerto/container

----------

# 📝 13. Checklist Final
<img width="451" height="397" alt="image" src="https://github.com/user-attachments/assets/78edd570-df2d-4406-b188-72554ef9c871" />

-     
    

----------

# 👥 14. Autores

-   Equipo DevOps — ORT ATI 2025
