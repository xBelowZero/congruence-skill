# Install congruence on Continue.dev

> Auto-discovered from `.continue/rules/` directory.

## What you get

- Methodology in Continue's rules system
- 5-step Gate Function before any claim/commit/PR
- Frontmatter `alwaysApply: false` — rule applies when context-relevant

## Quick install

```bash
cd your-project/
mkdir -p .continue/rules
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/continue/congruence.md -o .continue/rules/congruence.md
```

## How to invoke

By default `alwaysApply: false` — Continue applies the rule when contextually relevant. To force always-on, edit frontmatter to `alwaysApply: true`.

Or use `globs:` field to scope:

```yaml
globs: ["**/README*", "**/CHANGELOG*", "**/docs/**"]
```

## Limitations vs Claude Code

- **No hooks** — Continue has no Stop hook equivalent.
- **No Task tool** — for independent audit, open new Continue chat and paste [auditor-prompt](https://github.com/xBelowZero/congruence-skill/blob/main/auditor-prompt.md).

## Updating

```bash
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/continue/congruence.md -o .continue/rules/congruence.md
```

## Reference

- Continue.dev Rules: https://docs.continue.dev/customize/deep-dives/rules
