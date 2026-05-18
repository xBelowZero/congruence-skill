# Install congruence on GitHub Copilot

> Auto-injected on every Copilot Chat session in this repo. Ambient (no manual invocation needed).

## What you get

- Congruence methodology auto-included in Copilot's context for this repo
- 5-step Gate Function before any claim/commit/PR
- No manual invocation needed — Copilot reads `.github/copilot-instructions.md` automatically

## Quick install

```bash
cd your-project/
mkdir -p .github
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/copilot/copilot-instructions.md \
  -o .github/copilot-instructions.md
```

Commit and push — Copilot picks it up immediately.

## How to invoke

Ambient. Just chat with Copilot as usual. The instructions are silently appended to every prompt.

To force the audit, ask explicitly: `audit congruence of these changes before I commit`.

## Limitations vs Claude Code

- **No hooks** — Copilot has no Stop/PostToolUse equivalent. The audit relies on Copilot reading the instructions.
- **No Task tool** — to dispatch an independent auditor, open a new Copilot Chat session and paste the [auditor-prompt](https://github.com/xBelowZero/congruence-skill/blob/main/auditor-prompt.md).
- **Repo-scoped** — instructions apply only to this repo. For global, no equivalent exists; you'd need to copy per-repo.

## Updating

```bash
curl -L https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/copilot/copilot-instructions.md \
  -o .github/copilot-instructions.md
```

## Reference

- GitHub Copilot custom instructions: https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot
