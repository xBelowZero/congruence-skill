# Congruence — Auditoría de Verdad Semántica para Agentes de IA

> **Auditoría de congruencia semántica para agentes de IA de coding.** Verifica que lo que un agente de IA dice, escribe o documenta realmente coincida con lo que el proyecto hace. No es revisión técnica de código — chequea si las afirmaciones sobre el código son verdaderas.

[🇺🇸](README.md) · [🇧🇷](README.pt-BR.md) · 🇪🇸 · [🇫🇷](README.fr.md) · [🇩🇪](README.de.md) · [🇨🇳](README.zh.md)

---

## Qué es

Los agentes de IA de coding alucinan. Generan código que parece correcto pero describe cosas que no existen, escriben READMEs desalineados con el código real, o inventan integraciones. Esta skill audita esa clase de error — **incongruencia semántica**.

**Principio central:** Ninguna afirmación sobre el proyecto es verdadera sin evidencia en el propio proyecto.

## Qué captura

Cualquier divergencia entre lo que el agente (o los docs, UI, copy y configs del proyecto) **afirma** y lo que el código **de hecho hace** — en cualquier dominio, stack o lenguaje. Donde haya una afirmación verificable contra el código fuente, `congruence` la chequea.

Algunos ejemplos ilustrativos (no exhaustivos): un FAQ describiendo un flujo de 3 pasos cuando son 5; un README documentando precio $49 mientras Stripe cobra $79; una landing anunciando "integración con Stripe" que es solo un `// TODO`; setup pidiendo Node 18 cuando el proyecto requiere Node 20; "123 leads activos" contando leads eliminados; CTA "Obtén cupo gratis" llevando a checkout de $497; función renombrada en 1 archivo con 47 callsites rotos; doc afirmando que una feature existe cuando solo un mock devuelve `success`.

Todo esto **pasa cualquier revisión técnica de código** porque el código compila y corre. `congruence` es la barrera contra esta clase de bug.

## Plataformas de IA soportadas

| Plataforma | Adaptador | Estado |
|------------|-----------|--------|
| **Claude Code** (CLI / IDE / web) | `SKILL.md` raíz | ✅ Principal |
| **Cursor** | [`adapters/cursor/`](adapters/cursor/) | ✅ Soportado |
| **GitHub Copilot** | [`adapters/copilot/`](adapters/copilot/) | ✅ Soportado |
| **Gemini CLI / Antigravity** | [`adapters/gemini/`](adapters/gemini/) | ✅ Soportado |
| **OpenAI Codex CLI** | [`adapters/codex/`](adapters/codex/) | ✅ Soportado |
| **Aider** | [`adapters/aider/`](adapters/aider/) | ✅ Soportado |
| **Qwen Code CLI** (Alibaba) | [`adapters/qwen/`](adapters/qwen/) | ✅ Soportado |
| **Kimi K2** (Moonshot AI) | [`adapters/kimi/`](adapters/kimi/) | ✅ Soportado |
| **Windsurf** (Codeium) | [`adapters/windsurf/`](adapters/windsurf/) | ✅ Soportado |
| **Cline** (VS Code) | [`adapters/cline/`](adapters/cline/) | ✅ Soportado |
| **Continue.dev** | [`adapters/continue/`](adapters/continue/) | ✅ Soportado |
| **Zed Editor** | [`adapters/zed/`](adapters/zed/) | ✅ Soportado |
| **JetBrains Junie** | [`adapters/jetbrains-junie/`](adapters/jetbrains-junie/) | ✅ Soportado |
| **Sourcegraph Cody** | [`adapters/cody/`](adapters/cody/) | ✅ Soportado |
| **ChatGPT Custom GPT** | [`adapters/chatgpt-custom-gpt/`](adapters/chatgpt-custom-gpt/) | ✅ Soportado |
| **LLM genérico** (ChatGPT.com, Claude.ai, cualquier chat) | [`adapters/generic-prompt/`](adapters/generic-prompt/) | ✅ Soportado |
Cada adaptador tiene su propio `INSTALL.md` con pasos específicos de la plataforma.

## Install rápido (Claude Code)

```bash
# Proyecto-local (recomendado)
cd your-project/
mkdir -p .claude/skills
git clone https://github.com/brunnocarpena/congruence-skill.git .claude/skills/congruence

# O global (todos los proyectos)
mkdir -p ~/.claude/skills
git clone https://github.com/brunnocarpena/congruence-skill.git ~/.claude/skills/congruence
```

Invocar en una sesión: `/congruence` o "audita la congruencia del trabajo de esta sesión".

Para otras plataformas, ve el `adapters/<platform>/INSTALL.md` relevante.

## Cómo funciona

1. Identifica archivos cambiados en la sesión
2. Extrae afirmaciones verificables del output del agente
3. Busca evidencia en la jerarquía de fuente-de-verdad
4. Clasifica cada afirmación: `congruent` / `incongruent` / `partial` / `unverifiable`
5. Genera reporte estructurado
6. Emite decisión pre-deploy

Workflow completo: [SKILL.md](SKILL.md).

## Diferencia vs. otras skills

| Skill | Qué chequea |
|-------|-------------|
| `congruence` | Verdad semántica: ¿las afirmaciones coinciden con el código? |
| `verification-before-completion` | El código funciona: tests pasan, build exitoso |
| `requesting-code-review` | Calidad técnica: bugs, patrones, mantenibilidad |
| `systematic-debugging` | Root cause de bugs reproducibles |

Las skills son complementarias. `congruence` ocupa el nicho del **drift entre lo que se dice y lo que el código hace** — gap no cubierto por las otras.

## Estructura del repositorio

```
congruence-skill/
├── SKILL.md                   # Workflow + Ley de Hierro + tablas (EN primario)
├── SKILL.pt-BR.md             # Portugués (Brasil)
├── SKILL.es.md                # Español
├── SKILL.fr.md                # Francés
├── SKILL.de.md                # Alemán
├── SKILL.zh.md                # Chino
├── README.md / .pt-BR / .es / .fr / .de / .zh
├── auditor-prompt.md          # Plantilla para dispatch de subagente (+ traducciones)
├── checks/                    # Disclosure progresiva por dominio
│   ├── docs.md                #   README, CHANGELOG, /docs
│   ├── ui-copy.md             #   labels, buttons, headlines
│   ├── data-numbers.md        #   precios, fechas, counts
│   ├── integrations.md        #   Stripe, OAuth, webhooks
│   └── features-flows.md      #   features y flujos anunciados
├── references/                # Guías profundas
├── examples/                  # Casos de estudio
├── hooks/                     # OPCIONAL: auto-sugerencia de Claude Code
├── adapters/                  # Otras plataformas de IA
│   ├── cursor/
│   ├── github-copilot/
│   ├── gemini/
│   ├── openai-codex/
│   ├── aider/
│   └── generic-prompt/
└── scripts/
```

## Contribuir

Issues y PRs bienvenidos. Antes de abrir un PR:

1. Lee `SKILL.md` para entender el workflow
2. Si añades un nuevo tipo de check, considera si entra en `references/` o merece su propio archivo en `checks/`
3. Los ejemplos deben ser **genéricos** (no específicos a stack X o framework Y)
4. Traducciones: mantén todas las versiones de idioma sincronizadas (PT-BR y EN son referencia)

## Licencia

MIT — ver [LICENSE](LICENSE).

## Inspiración

Patrones y estructura inspirados por:
- [obra/superpowers](https://github.com/obra/superpowers) — especialmente `verification-before-completion` y `writing-skills`
- [anthropics/skills](https://github.com/anthropics/skills) — `skill-creator` y best practices oficiales
- [Docs de Anthropic Agent Skills](https://docs.claude.com/en/docs/claude-code/skills)