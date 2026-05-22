# Install congruence on JetBrains Junie / AI Assistant

> Auto-loaded via `.junie/guidelines.md` at project root.

## What you get

- Methodology auto-included in Junie's context
- 5-step Gate Function before any claim/commit/PR
- Works in IntelliJ IDEA, PyCharm, WebStorm, GoLand, RubyMine, etc.

## Quick install

```bash
cd your-project/
mkdir -p .junie
curl -L https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/jetbrains-junie/guidelines.md -o .junie/guidelines.md
```

Alternatively, JetBrains now also supports `AGENTS.md` at project root — see the `adapters/codex/` for that route.

## How to invoke

Ambient. Junie auto-discovers `.junie/guidelines.md`.

## Limitations vs Claude Code

- **No hooks** — Junie has no Stop hook equivalent.
- **No Task tool** — for independent audit, open new Junie session and paste [auditor-prompt](https://github.com/brunnocarpena/congruence-skill/blob/main/auditor-prompt.md).
- **IDE-only** — Junie requires JetBrains IDE; no CLI usage.

## Updating

```bash
curl -L https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/jetbrains-junie/guidelines.md -o .junie/guidelines.md
```

## Reference

- Junie Guidelines: https://www.jetbrains.com/help/junie/customize-guidelines.html
- Guidelines & Memory: https://junie.jetbrains.com/docs/guidelines-and-memory.html
