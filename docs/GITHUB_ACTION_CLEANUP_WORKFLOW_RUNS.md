# GitHub Action: Limpieza Automática de Workflow Runs

## 📋 Descripción

Este workflow de GitHub Actions limpia automáticamente TODOS los workflow runs de TODOS tus repositorios cada 48 horas.

## 🚀 Características

✅ **Ejecución automática** cada 48 horas
✅ **Ejecución manual** cuando lo necesites
✅ **Detección inteligente de rate limit** - se detiene si alcanza el límite
✅ **Sin límite de 200 runs** - limpia TODOS los runs de cada repositorio
✅ **Genérico** - obtiene todos los repositorios automáticamente
✅ **Continúa en la siguiente ejecución** si se detiene por rate limit

## 📁 Ubicación

```
.github/workflows/cleanup-workflow-runs.yml
```

## ⚙️ Configuración

### Programación Automática

El workflow se ejecuta automáticamente:
- **Cada 48 horas** a las 3:00 AM UTC
- Puedes cambiar la frecuencia editando el cron:

```yaml
schedule:
  - cron: '0 3 */2 * *'  # Cada 48 horas
```

**Ejemplos de cron:**
- `'0 3 * * *'` - Cada día a las 3:00 AM
- `'0 3 */3 * *'` - Cada 3 días a las 3:00 AM
- `'0 3 * * 0'` - Cada domingo a las 3:00 AM
- `'0 3 1 * *'` - El día 1 de cada mes a las 3:00 AM

### Ejecución Manual

Puedes ejecutar el workflow manualmente:

1. Ve a tu repositorio en GitHub
2. Click en **Actions**
3. Selecciona **"Limpiar Workflow Runs Antiguos"**
4. Click en **"Run workflow"**
5. Click en **"Run workflow"** de nuevo

## 🔐 Permisos Necesarios

El workflow usa `GITHUB_TOKEN` que tiene permisos automáticos para:
- Leer repositorios
- Eliminar workflow runs

**No necesitas configurar nada adicional.**

## 📊 Funcionamiento

### 1. Verificación Inicial de Rate Limit

Antes de empezar, verifica que haya suficientes requests disponibles (mínimo 100).

### 2. Obtención de Repositorios

Obtiene automáticamente TODOS tus repositorios (hasta 1000).

### 3. Limpieza por Repositorio

Para cada repositorio:
- Obtiene workflow runs en páginas de 200
- Elimina TODOS los runs (sin límite)
- Verifica rate limit antes de cada repositorio
- Se detiene si alcanza el límite

### 4. Resumen Final

Muestra:
- Repositorios procesados
- Total de workflow runs eliminados
- Estado del rate limit

## 📈 Ejemplo de Salida

```
=========================================
  LIMPIEZA DE WORKFLOW RUNS
=========================================

[1/58 - 1.7%] TokyoghoulEs/GhoulStream
   ✓ Sin workflow runs

[2/58 - 3.4%] TokyoghoulEs/time
   Eliminando 200 workflow runs...
   Eliminando 200 workflow runs...
   Eliminando 200 workflow runs...
   Eliminando 200 workflow runs...
   Eliminando 9 workflow runs...
   ✅ Eliminados: 809 runs

...

=========================================
  RESUMEN FINAL
=========================================
Repositorios procesados: 58 de 58
Total workflow runs eliminados: 809

✅ Limpieza completada exitosamente
```

## 🛑 Manejo de Rate Limit

### Límites de GitHub Actions

- **5000 requests/hora** para el GITHUB_TOKEN
- El workflow verifica el límite antes de cada repositorio
- Se detiene automáticamente si quedan menos de 50 requests

### Si Alcanza el Límite

El workflow:
1. Se detiene automáticamente
2. Muestra cuántos repositorios procesó
3. Muestra cuántos runs eliminó
4. Continuará en la próxima ejecución programada (48 horas)

### Ejemplo de Detención por Rate Limit

```
[30/58 - 51.7%] TokyoghoulEs/repo-ejemplo
🛑 Rate limit alcanzado (45 requests restantes)
   Deteniendo limpieza. Se continuará en la próxima ejecución.

=========================================
  RESUMEN FINAL
=========================================
Repositorios procesados: 30 de 58
Total workflow runs eliminados: 2500

⚠️ Limpieza parcial debido a rate limit
   Se continuará en la próxima ejecución programada
```

## 🔧 Personalización

### Cambiar Frecuencia de Ejecución

Edita el archivo `.github/workflows/cleanup-workflow-runs.yml`:

```yaml
on:
  schedule:
    - cron: '0 3 */2 * *'  # Cambiar aquí
```

### Cambiar Umbral de Rate Limit

Cambia el valor en la línea:

```bash
if [ "$REMAINING" -lt 50 ]; then  # Cambiar 50 por otro valor
```

### Cambiar Límite de Runs por Iteración

Cambia el valor en la línea:

```bash
RUNS=$(gh run list --repo "$repo" --limit 200 ...)  # Cambiar 200
```

## 📝 Notas Importantes

### 1. Primera Ejecución

Si tienes muchos workflow runs acumulados:
- La primera ejecución puede alcanzar el rate limit
- Ejecutará de nuevo en 48 horas y continuará
- Después de 2-3 ejecuciones, estará todo limpio

### 2. Repositorios Nuevos

El workflow obtiene la lista de repositorios dinámicamente:
- No necesitas actualizar nada cuando agregues nuevos repos
- Se incluirán automáticamente en la próxima ejecución

### 3. Workflow Runs del Propio Workflow

Este workflow también limpia sus propios runs antiguos.

### 4. No Afecta el Código

Solo elimina workflow runs (historial de ejecuciones):
- No afecta el código fuente
- No afecta las configuraciones
- No afecta otros workflows

## 🐛 Solución de Problemas

### El workflow no se ejecuta automáticamente

**Causa:** GitHub Actions desactiva workflows en repos inactivos después de 60 días.

**Solución:**
1. Ve a Actions en tu repositorio
2. Habilita el workflow manualmente
3. O haz un commit para reactivar el repo

### Error: "Resource not accessible by integration"

**Causa:** Permisos insuficientes del GITHUB_TOKEN.

**Solución:**
1. Ve a Settings → Actions → General
2. En "Workflow permissions", selecciona "Read and write permissions"
3. Guarda los cambios

### El workflow se detiene muy rápido

**Causa:** Rate limit ya estaba bajo cuando empezó.

**Solución:**
- Espera 1 hora para que se resetee el rate limit
- Ejecuta manualmente de nuevo

## 📊 Monitoreo

### Ver Ejecuciones

1. Ve a tu repositorio en GitHub
2. Click en **Actions**
3. Selecciona **"Limpiar Workflow Runs Antiguos"**
4. Verás todas las ejecuciones con su estado

### Ver Logs Detallados

1. Click en una ejecución específica
2. Click en el job "cleanup"
3. Expande cada paso para ver los logs

## 🎯 Ventajas vs Script Local

| Característica | Script Local | GitHub Action |
|----------------|--------------|---------------|
| Ejecución automática | ❌ Manual | ✅ Cada 48h |
| Requiere PC encendida | ✅ Sí | ❌ No |
| Usa tu rate limit | ✅ Sí | ❌ Usa el del repo |
| Configuración | ❌ Compleja | ✅ Simple |
| Logs históricos | ❌ No | ✅ Sí |

## 🔄 Migración desde Script Local

Si ya usabas el script local de PowerShell:

1. **Deja de ejecutar** el script local
2. **Habilita** el workflow de GitHub Actions
3. **Ejecuta manualmente** la primera vez para verificar
4. **Deja que se ejecute automáticamente** cada 48 horas

## 📚 Referencias

- [GitHub Actions - Scheduled Events](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule)
- [GitHub CLI - gh run](https://cli.github.com/manual/gh_run)
- [GitHub API Rate Limits](https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting)

---

**Última actualización:** 2025-11-26
**Versión:** 1.0
**Probado con:** 58 repositorios, ~800 workflow runs
