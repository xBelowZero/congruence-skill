# Install congruence on Qwen Code CLI

> Auto-loaded into Qwen Code's hierarchical memory via `QWEN.md`. Qwen Code is the Alibaba fork of Gemini CLI for Qwen3-Coder.

## What you get

- Methodology auto-included on every Qwen Code session
- 5-step Gate Function before any claim/commit/PR
- Supports `@file.md` imports for modular context

## Quick install

Project-local:
```bash
cd your-project/
curl -L https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/qwen/QWEN.md -o QWEN.md
```

Global:
```bash
mkdir -p ~/.qwen
curl -L https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/qwen/QWEN.md -o ~/.qwen/QWEN.md
```

## How to invoke

Ambient. Verify with `/memory show` in Qwen Code.

## Limitations vs Claude Code

- **No hooks** — Qwen Code has no Stop hook equivalent.
- **No Task tool** — to dispatch a fresh auditor, open a new Qwen Code session and paste [auditor-prompt](https://github.com/brunnocarpena/congruence-skill/blob/main/auditor-prompt.md).

## Updating

```bash
curl -L https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/qwen/QWEN.md -o QWEN.md
```

## Reference

- Qwen Code: https://github.com/QwenLM/qwen-code
- Memory docs: https://qwenlm.github.io/qwen-code-docs/en/core/memport/
