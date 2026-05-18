---
name: congruence
description: Usa siempre que estés a punto de declarar trabajo completo, hacer commit, abrir un PR, actualizar README/CHANGELOG/docs, o entregar un cambio que afecte texto visible para el usuario — audita si lo que el agente dijo, escribió o documentó realmente coincide con lo que hace el código. Usa proactivamente antes de CUALQUIER afirmación de finalización. ACTIVA cuando el agente use frases como "ahora soporta", "implementado", "funciona", "listo", "arreglado", "añadido"; cuando los archivos modificados incluyan README, CHANGELOG, docs/, help-center, FAQ, landing page, copy de UI o prompts de IA; antes de release/deploy. OMITE cuando los cambios sean solo de formato, bumps de versión de dependencias, refactors internos sin tocar texto visible, o cambios solo de tests.
argument-hint: [scope?] [--dispatch-agent?]
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(scripts/scan-changed-files.sh:*), Task
---

# Congruencia

Audita si lo que el agente dijo, escribió o documentó coincide con lo que el código realmente hace. **Esto no es revisión técnica de código.** Es una auditoría de **verdad semántica**.

**Principio central:** Ninguna afirmación sobre el proyecto es verdadera sin evidencia en el propio proyecto.

**Violar la letra de esta regla es violar su espíritu.** El texto que el agente acaba de generar nunca es fuente de verdad — ni siquiera con coletillas como "probablemente", "debería ser", "asumí que".

## La Ley de Hierro

```
NINGUNA AFIRMACIÓN VISIBLE AL USUARIO SIN EVIDENCIA DE TERRENO
```

Si escribiste "la app ahora hace X" y no puedes señalar el archivo/test/ruta que prueba X, **no puedes** publicar esa afirmación. Degrádala a "planificado", "parcial", o elimínala.

## Función de Compuerta — antes de cualquier afirmación o edición de docs

Ejecuta en orden. Cada paso bloquea al siguiente si está incompleto.

1. **EXTRAER** — lista cada afirmación concreta del output ("soporta X", "arregló Y", "ahora muestra Z"). Consulta [references/claim-extraction-guide.md](references/claim-extraction-guide.md) si necesitas técnicas.
2. **MAPEAR** — para cada afirmación, señala el file:line/test/ruta que la prueba. ¿Sin objetivo? Márcala como `unverifiable`.
3. **AUDITAR** — para cada afirmación sin prueba: **bórrala** o **degrádala** a "planificado/parcial/en-progreso".
4. **VERIFICACIÓN CRUZADA** — asegura que la terminología en docs coincide con el código (nombres de funciones, env vars, rutas, labels).
5. **EMITIR** — solo ahora generar el mensaje/commit/PR/release notes.

## Tabla de evidencia por tipo de afirmación

| Afirmación | Requiere | No es suficiente |
|------------|----------|------------------|
| "Ahora soporta X" | Test pasando + nombre de función/ruta grepable | "Añadí un TODO", "existe el scaffolding" |
| "Arreglé el bug Y" | Test fallando → test pasando (red-green) | "Cambié el código, parece correcto" |
| "El README dice X" | grep README + grep código, ambos contienen X | Solo editar el README |
| "Renombré Y a Z" | grep en todo el repo: 0 ocurrencias de Y | Renombrado en 1 archivo |
| "Eliminé la feature W" | grep código + README + tests → 0 ocurrencias | Eliminado solo del código |
| "Integra con Stripe/X" | Código + env var + handler/webhook configurado | mock o `// TODO: integrate Stripe` |
| "Precio/fecha/número X" | grep del valor literal en source (config, db seed o hard-coded) | El número aparece solo en copy generado |
| "Tiene X opciones en select" | El componente lista exactamente X items, no un mock | "debería tener alrededor de X opciones" |

Guía más profunda: [references/source-of-truth-priority.md](references/source-of-truth-priority.md)

## Banderas Rojas — DETENTE

Si te sorprendes pensando o escribiendo:

- "debería funcionar", "probablemente sea", "asumí que", "es implícito"
- Escribir el README **antes** del código (o después, sin releer el código)
- Pegar una descripción de PR generada por LLM sin grep
- "Mencionaré X en los docs, el usuario averigua la ortografía exacta"
- Renombrar una función sin grep en todo el repo
- El reporte de estado incluye una feature implementada "antes en la sesión" sin reverificar
- `package.json`/`README` describen algo diferente de lo que hace el entry point
- Copy de marketing/landing promete un beneficio sin código detrás

→ DETENTE. Vuelve al paso 1 de la Función de Compuerta.

## Tabla Excusa | Realidad

| Excusa | Realidad |
|--------|----------|
| "El usuario arregla el README después" | Una afirmación publicada = una afirmación hecha. Verifica o elimina. |
| "Bastante cerca" | Cerca ≠ verdadero. El código es binario, la afirmación también. |
| "Son solo docs" | Los docs **son** el producto para los agentes downstream. |
| "La intención es clara" | Intención ≠ implementación. Audita la implementación. |
| "Estoy describiendo el diseño, no el estado actual" | Entonces di "planificado", no uses tiempo presente. |
| "El espíritu del cambio es correcto" | La letra ES el espíritu. Audita el diff real. |
| "Solo esta vez" | No existe el solo-esta-vez. Toda afirmación se audita. |

## Workflow

### 1. Identificar scope

```bash
bash scripts/scan-changed-files.sh
```

O usa git diff directamente. Lista archivos creados/modificados en la sesión.

Si `$ARGUMENTS` contiene un scope específico (ej. `/congruence headlines`, `/congruence pricing`), filtra solo archivos/áreas que coincidan con el scope.

### 2. Extraer afirmaciones

Lee cada output de la sesión y cada archivo modificado. Transforma declaraciones implícitas y explícitas en afirmaciones objetivas. Guía: [references/claim-extraction-guide.md](references/claim-extraction-guide.md).

### 3. Buscar evidencia

Para cada afirmación, busca la fuente de verdad en la jerarquía (ejecutable > rutas/handlers > schemas > tests > config > UI > mocks > docs > README > comentarios > texto del agente).

### 4. Clasificar

| Estado | Significado |
|--------|-------------|
| `congruent` | La evidencia confirma |
| `incongruent` | La evidencia contradice |
| `partially congruent` | Parte correcta, omisiones importantes |
| `unverifiable` | Evidencia insuficiente |

Severidad: [references/severity-rubric.md](references/severity-rubric.md).

### 5. Reportar

Plantilla obligatoria: [references/report-format.md](references/report-format.md).

### 6. Decisión pre-deploy

- Cualquier `critical` → **no aprobar**
- `high` no resuelto → **no aprobar**
- Muchos `unverifiable` en áreas esenciales → **requerir revisión manual**
- Solo `medium`/`low` → **aprobar con observaciones**
- Todo `congruent` → **aprobar**

## Dispatch del subagente auditor (opcional)

Cuando el scope es grande (auditoría de página completa, release notes largas, múltiples áreas), el agente actual puede estar sesgado por haber generado las afirmaciones. **Despachar un subagente fresco evita la auto-confirmación.**

**Cuándo preguntar al usuario sobre el dispatch:**
- Más de 5 afirmaciones a auditar
- Cambios tocan 3+ dominios distintos (docs + UI + integraciones, por ejemplo)
- Release notes o descripción de PR de más de 200 líneas
- El usuario dijo "audita todo" sin especificar scope

**Cómo preguntar:**

> "Detecté N afirmaciones en M áreas. ¿Quieres que despache un subagente especialista para auditar en paralelo? (sí/no/solo esta parte)"

**Si el usuario acepta** (o si se invoca con `/congruence --dispatch-agent`):
- Usa la tool Task con la plantilla en [auditor-prompt.md](auditor-prompt.md)
- Pasa el scope, lista de afirmaciones extraídas y SHAs base/head
- Espera el reporte estructurado y consolida en la decisión final

**Si corre inline**: continúa con el workflow arriba.

> **Costo oculto**: cada subagente recarga CLAUDE.md + todas las descripciones de skills. Dispatch es caro para auditorías pequeñas. El default es inline.

## Cuándo NO usar

- Revisión técnica de código (bugs, performance, seguridad) → usa `requesting-code-review`
- Verificar que el código compila / pasan los tests → usa `verification-before-completion`
- Linting, formato
- Revisión aislada de unit-test

## Skills relacionadas

- **superpowers:verification-before-completion** — verifica que el **código funciona** (tests, build). `congruence` verifica que las **afirmaciones sobre el código** coinciden con el código. Usa ambos antes de cualquier release.
- **superpowers:systematic-debugging** — cuando una auditoría de congruencia revela "el código hace X pero los docs dicen Y", debuggea sistemáticamente en vez de solo parchear el doc.
- **superpowers:requesting-code-review** — calidad técnica. Complementario, no sustituto.

## Por qué importa

Los agentes alucinan. La revisión técnica de código no captura esto porque el código es correcto — lo que está mal es la **información sobre el código**.

Ejemplos reales:
- El FAQ describe un flujo de 3 pasos cuando son 5
- El README documenta precio $49 pero Stripe cobra $79
- La landing anuncia integración con WhatsApp que no existe
- El setup pide Node 18 pero el proyecto requiere Node 20
- "123 leads activos" cuenta leads eliminados
- CTA dice "Reclama tu cupo gratis" y lleva a un checkout de $497
- Headline en EN, formulario en ES (idiomas mezclados)
- Fecha "17 May 2026" en hero, "05/17/2025" en footer

Todo esto **pasa la revisión técnica de código** porque el código compila y corre. `congruence` es la barrera contra este tipo de error.

## Reglas inviolables

1. El texto que el agente acaba de generar **nunca** es fuente de verdad
2. La plausibilidad **no** es prueba — se requiere evidencia concreta
3. Sin evidencia → `unverifiable`, **nunca** `congruent`
4. Issues `critical`/`high` **bloquean** deploy/merge
5. Reporte generado **siempre**, aunque todo sea `congruent`
6. **Violar la letra es violar el espíritu** — sin excepciones, sin "solo esta vez"

---

**Idiomas:** [🇺🇸 English](SKILL.md) · [🇧🇷 Português](SKILL.pt-BR.md) · 🇪🇸 Español · [🇫🇷 Français](SKILL.fr.md) · [🇩🇪 Deutsch](SKILL.de.md) · [🇨🇳 中文](SKILL.zh.md)