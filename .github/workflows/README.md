# GitHub Actions Workflows

## 📋 Workflows Disponibles

### 🧹 Limpiar Workflow Runs Antiguos

**Archivo:** `cleanup-workflow-runs.yml`

**Descripción:** Limpia automáticamente TODOS los workflow runs de TODOS los repositorios cada 48 horas.

**Ejecución:**
- ⏰ Automática: Cada 48 horas a las 3:00 AM UTC
- 🖱️ Manual: Actions → "Limpiar Workflow Runs Antiguos" → Run workflow

**Características:**
- ✅ Limpia TODOS los runs sin límite de 200
- ✅ Detecta y maneja rate limit automáticamente
- ✅ Obtiene repositorios dinámicamente (genérico)
- ✅ Continúa en la siguiente ejecución si se detiene

**Documentación completa:** [docs/GITHUB_ACTION_CLEANUP_WORKFLOW_RUNS.md](../../docs/GITHUB_ACTION_CLEANUP_WORKFLOW_RUNS.md)

---

## 🚀 Uso Rápido

### Ejecutar Manualmente

1. Ve a **Actions** en GitHub
2. Selecciona el workflow
3. Click en **"Run workflow"**
4. Confirma con **"Run workflow"**

### Ver Resultados

1. Ve a **Actions**
2. Click en la ejecución más reciente
3. Expande los pasos para ver logs detallados

---

## 📊 Estado de los Workflows

| Workflow | Estado | Última Ejecución | Próxima Ejecución |
|----------|--------|------------------|-------------------|
| Limpiar Workflow Runs | ✅ Activo | Ver Actions | Cada 48h |

---

## 🔧 Configuración

Todos los workflows usan `GITHUB_TOKEN` automáticamente. No necesitas configurar secrets adicionales.

**Permisos necesarios:**
- Settings → Actions → General → Workflow permissions → "Read and write permissions"

---

## 📚 Más Información

- [Documentación de GitHub Actions](https://docs.github.com/en/actions)
- [GitHub CLI](https://cli.github.com/)
- [Cron Syntax](https://crontab.guru/)
