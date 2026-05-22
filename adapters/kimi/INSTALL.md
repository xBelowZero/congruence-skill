# Install congruence on Kimi CLI / Kimi K2

> **Status:** As of late 2025, Kimi CLI (MoonshotAI) does **not** have a documented project-memory file (no `KIMI.md` equivalent to `CLAUDE.md` / `GEMINI.md`). This adapter is **paste-per-session**.

## What you get

- Methodology activated for your current Kimi session
- 5-step Gate Function enforced by Kimi K2
- Works with Kimi CLI or Kimi web chat

## Quick install

There's nothing to install. Just paste:

1. Open Kimi CLI: `kimi`
2. Copy the entire content of [`KIMI-PROMPT.md`](https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/kimi/KIMI-PROMPT.md)
3. Paste as your first message
4. Continue normal conversation

## How to invoke

After pasting:

```
I'm about to commit these changes: [paste diff or files]. Audit congruence.
```

## Limitations vs Claude Code

- **No persistent memory** — methodology must be re-pasted each new Kimi session.
- **No hooks, no Task tool** — fully manual workflow.
- **MCP available** — if you set up Kimi with MCP servers, you can give it file system tools and it becomes more capable, but the congruence rules still need to be in the prompt.
- **If a `KIMI.md` convention emerges**, this adapter will be updated to support it.

## Reference

- Kimi CLI: https://github.com/MoonshotAI/kimi-cli
- Moonshot AI platform: https://platform.moonshot.ai/

> If you discover an updated Kimi project-memory convention, please open a PR.
