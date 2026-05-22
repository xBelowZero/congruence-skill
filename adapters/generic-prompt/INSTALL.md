# Use congruence with any LLM (ChatGPT, Claude.ai, Gemini, etc.)

> Paste-and-use prompt — no install, works in any chat interface.

## What you get

- Methodology activated for your current chat session
- 5-step Gate Function enforced by the LLM
- Works on ChatGPT (web), Claude.ai, Gemini, Perplexity, Mistral Chat, DeepSeek, any LLM with chat UI

## Quick install

1. Open a fresh chat with your preferred LLM
2. Copy the entire content of [`congruence-prompt.md`](https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/generic-prompt/congruence-prompt.md)
3. Paste it as your first message
4. Continue normal conversation — the LLM will audit your claims

## How to invoke

After pasting:

```
I'm about to commit these changes: [paste diff or files]. Audit.
```

Or for an existing piece of copy:

```
I want to publish this landing page: [paste]. Audit against this code: [paste].
```

## Limitations vs Claude Code

- **No file system access** — the LLM cannot grep/read your repo. You must paste source files when asked.
- **No automation** — purely manual workflow.
- **Session-scoped** — methodology resets when you start a new chat (paste prompt again).
- **Best with reasoning models** — GPT-5, Claude Opus, Gemini 2.5 Pro, DeepSeek R1 produce better audits than smaller models.

## Updating

Re-copy the latest version of [`congruence-prompt.md`](https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/generic-prompt/congruence-prompt.md) any time.

## Reference

- Full skill: https://github.com/brunnocarpena/congruence-skill
