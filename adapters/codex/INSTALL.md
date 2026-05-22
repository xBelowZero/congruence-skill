# Install congruence on OpenAI Codex CLI

> Auto-parsed via `AGENTS.md` at project root.

## What you get

- Congruence methodology in every Codex session for this project
- 5-step Gate Function before any claim/commit/PR
- Nested `AGENTS.md` in subdirectories override root for that subtree

## Quick install

```bash
cd your-project/
curl -L https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/codex/AGENTS.md -o AGENTS.md
```

If you already have an `AGENTS.md`, append the congruence section manually rather than overwriting.

## How to invoke

Ambient. Codex auto-loads `AGENTS.md` from CWD and walks up.

## Limitations vs Claude Code

- **No hooks** — Codex CLI cannot auto-trigger the audit at end of turn.
- **No Task tool** — to dispatch a fresh auditor, open a new Codex session and paste [auditor-prompt](https://github.com/brunnocarpena/congruence-skill/blob/main/auditor-prompt.md).
- **AGENTS.md is shared** — if other tools (Cursor, Aider) also read it, the methodology applies cross-tool (this is actually a feature).

## Updating

```bash
curl -L https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/codex/AGENTS.md -o AGENTS.md
```

## Reference

- AGENTS.md spec: https://agents.md/
- OpenAI Codex CLI: https://github.com/openai/codex
