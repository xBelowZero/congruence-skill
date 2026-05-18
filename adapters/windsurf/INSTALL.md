# Install congruence on Windsurf (Codeium)

> Auto-loaded via `.windsurf/rules/` directory with YAML frontmatter triggers.

## What you get

- Methodology auto-included via Cascade's rules system
- Trigger: `model_decision` — Cascade decides when to invoke
- 5-step Gate Function before any claim/commit/PR

## Quick install

```bash
cd your-project/
mkdir -p .windsurf/rules
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/windsurf/congruence.md -o .windsurf/rules/congruence.md
```

## How to invoke

Ambient via `model_decision` trigger. To force, change frontmatter `trigger: always_on`.

Other trigger modes (edit frontmatter):
- `always_on` — every prompt (high context cost)
- `model_decision` — Cascade decides (default in this adapter)
- `glob` — when files matching `globs:` are touched
- `manual` — only when you mention `@congruence`

## Limitations vs Claude Code

- **12k char limit per workspace rule** (6k global) — methodology fits comfortably.
- **No hooks** — Windsurf has no Stop hook equivalent.
- **No Task tool** — for independent audit, open new Cascade session and paste [auditor-prompt](https://github.com/xBelowZero/congruence-skill/blob/main/auditor-prompt.md).

## Updating

```bash
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/windsurf/congruence.md -o .windsurf/rules/congruence.md
```

## Reference

- Windsurf Memories & Rules: https://docs.windsurf.com/windsurf/cascade/memories
