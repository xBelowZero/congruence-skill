# Install congruence on Zed editor

> Auto-included in Zed's Agent Panel via `.rules` at project root.

## What you get

- Methodology in Zed's Agent context
- 5-step Gate Function before any claim/commit/PR
- Works with any model Zed supports (Claude, GPT, Gemini, local)

## Quick install

```bash
cd your-project/
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/zed/.rules -o .rules
```

> If you already have a `.rules` file, append the congruence section manually.

## How to invoke

Ambient. Zed's Agent Panel auto-includes `.rules`.

Zed also accepts these alternative filenames (first match wins):
- `.rules` (preferred)
- `.cursorrules`
- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`

If you already use one of those, congruence content can go there instead.

## Limitations vs Claude Code

- **No hooks** — Zed has no Stop hook equivalent.
- **No Task tool** — for independent audit, open new Zed Agent thread and paste [auditor-prompt](https://github.com/xBelowZero/congruence-skill/blob/main/auditor-prompt.md).

## Updating

```bash
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/zed/.rules -o .rules
```

## Reference

- Zed AI Rules: https://zed.dev/docs/ai/rules
