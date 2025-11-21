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
13. Estrategia de Ramas (Branching Strategy)
14. Contacto

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

## 13) Estrategia de Ramas (Branching Strategy)

Para este proyecto se implementó una estrategia **Trunk-Based Development**, adaptada al flujo de trabajo del equipo y a los requerimientos del obligatorio. Esta estrategia permite ciclos de integración más rápidos, mayor visibilidad del trabajo en curso y despliegues automatizados basados en la rama principal.

### 🔹 Ramas principales
- **main**  
  Contiene el código estable y listo para despliegue.  
  Cada integración a `main` dispara el pipeline de GitHub Actions que ejecuta:
  - Validación de Terraform (fmt / validate)
  - Terraform Plan + Apply
  - Construcción y publicación de imágenes en ECR
  - Actualización del servicio ECS

### 🔹 Ramas de desarrollo
- **feature/\***  
  Cada nueva funcionalidad, fix o mejora se desarrolla en una rama temporal.  
  Ejemplos:
  - `feature/agregar-test-k6`
  - `feature/dockerfile-backend-opt`

  Estas ramas:
  1. Se crean desde `main`
  2. Se mantienen pequeñas y de corta duración
  3. Terminan en un **Pull Request** (PR) hacia `main`

### 🔹 Pull Requests (PR)
Los PRs son obligatorios para integrar cambios en `main`.  
Cada PR debe incluir:
- Descripción del cambio
- Qué componentes modifica (Dockerfile, Terraform, app, etc.)
- Checklist de pruebas locales realizadas
- Revisión de al menos un miembro del equipo

El merge solo se realiza cuando:
1. El PR está aprobado  
2. Los checks automáticos pasan (lint, build, validación de Terraform)

### 🔹 Política de Commits
- Commits pequeños y con mensajes claros.  
- Formato sugerido:
  - `feat: agregar prueba de carga k6`
  - `fix: variable de entorno faltante en task definition`
  - `chore: actualizar dependencias frontend`

### 🔹 Hotfixes
Para solucionar errores críticos detectados en producción:
- Crear rama `hotfix/<nombre>` desde `main`
- Arreglar el problema
- Hacer PR → merge a `main`
- El pipeline desplegará automáticamente el fix en ECS

### 🔹 Justificación de la decisión
Se eligió **Trunk-Based Development** porque:
- Minimiza conflictos de merge
- Acelera la integración continua
- Permite ciclos de entrega cortos y seguros
- Se integra de forma natural con la automatización del pipeline Terraform + ECS
- Es la estrategia recomendada para entornos orientados a DevOps, IaC y microservicios

Esta estrategia cumple con los criterios de la rúbrica del obligatorio, demostrando:
- Trabajo colaborativo
- Flujo de desarrollo claro y reproducible
- Uso consistente de PRs y control de versiones
