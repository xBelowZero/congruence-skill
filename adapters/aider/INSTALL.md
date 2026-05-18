# Install congruence on Aider

> Auto-loaded via `.aider.conf.yml` as cacheable read-only context.

## What you get

- Methodology read-only context in every Aider session
- 5-step Gate Function before any claim/commit/PR
- Cacheable (low token cost on repeat sessions)

## Quick install

```bash
cd your-project/
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/aider/CONVENTIONS.md -o CONVENTIONS.md
```

Then add to `.aider.conf.yml` at the project root (create if missing):

```yaml
read:
  - CONVENTIONS.md
```

Or for a single session:

```bash
aider --read CONVENTIONS.md
```

## How to invoke

Ambient. Aider treats the file as standing instructions.

## Limitations vs Claude Code

- **No hooks** — Aider has no Stop hook equivalent.
- **No Task tool** — to dispatch an independent auditor, open a new Aider session in a different terminal and paste [auditor-prompt](https://github.com/xBelowZero/congruence-skill/blob/main/auditor-prompt.md).
- **No subagents** — congruence is enforced by the same model handling implementation.

## Updating

```bash
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/aider/CONVENTIONS.md -o CONVENTIONS.md
```

## Reference

- Aider conventions docs: https://aider.chat/docs/usage/conventions.html
