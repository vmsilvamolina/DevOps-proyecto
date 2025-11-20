# StockWiz — Proyecto DevOps

> Repositorio para el entregable del Obligatorio DevOps (Agosto 2025).  
> Basado en el enunciado oficial del curso (ver PDF entregado por la cátedra). :contentReference[oaicite:1]{index=1}

---

## Resumen
StockWiz es la aplicación base entregada para el proyecto. Este repositorio contiene:
- Código de las aplicaciones (backend / frontend).
- Dockerfiles para containerización.
- Terraform para IaC (infraestructura en AWS).
- Workflows de GitHub Actions que realizan `plan` / `apply` de Terraform y despliegue.
- Scripts de testing y ejemplos de observabilidad.

> **Objetivo:** tener un pipeline totalmente automatizado que, al hacer `push` / `merge` a `main`, aplique la infraestructura con Terraform y despliegue la aplicación en AWS ECS.

---

## Índice
1. Requisitos previos  
2. Estructura del repositorio  
3. Variables de entorno y `.env.example`  
4. Instrucciones locales (build & run con Docker)  
5. Terraform — inicializar y aplicar  
6. GitHub Actions — pipelines (apply / destroy)  
7. Despliegue en AWS ECS (build, push a ECR, actualizar servicio)  
8. Observabilidad y alertas (sugerencia)  
9. Testing (sugerencia e instrucciones)  
10. Rollback y recuperación  
11. Troubleshooting  
12. Checklist para completar (placeholders)  
13. Contacto

---

## 1) Requisitos previos
- Git
- Docker (local)
- AWS CLI (configurado si vas a ejecutar comandos aws localmente)
- Terraform (v1.X+)
- Node / Java / .NET según el stack de la app (si vas a ejecutar localmente)
- `aws-cdk` no requerido a menos que lo uses
- Acceso a GitHub (repo) y permisos para crear/usar secrets

---

## 2) Estructura recomendada del repo
> Si la estructura difiere, actualizá las rutas en los pasos de abajo.

