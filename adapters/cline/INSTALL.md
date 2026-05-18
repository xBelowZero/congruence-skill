# Install congruence on Cline (VS Code extension)

> Auto-loaded via `.clinerules/` directory. Always active unless toggled off in Cline UI.

## What you get

- Methodology auto-included on every Cline session in this project
- 5-step Gate Function before any claim/commit/PR
- Toggleable per-session via Cline's rules UI

## Quick install

```bash
cd your-project/
mkdir -p .clinerules
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/cline/congruence.md -o .clinerules/congruence.md
```

## How to invoke

Ambient. Cline auto-loads all files in `.clinerules/`.

## Limitations vs Claude Code

- **No hooks** — Cline doesn't have Stop hook equivalent.
- **No Task tool** — to dispatch a fresh auditor, open a new Cline conversation and paste [auditor-prompt](https://github.com/xBelowZero/congruence-skill/blob/main/auditor-prompt.md).
- **Multiple rules** can coexist in `.clinerules/` — congruence won't conflict with others.

## Updating

```bash
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/cline/congruence.md -o .clinerules/congruence.md
```

## Reference

- Cline Rules: https://docs.cline.bot/features/cline-rules
