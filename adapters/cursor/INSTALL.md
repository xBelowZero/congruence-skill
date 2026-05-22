# Install congruence on Cursor

> Audits semantic congruence between agent claims and code reality. Manual invocation via `@congruence`.

## What you get

- An Agent-Requested Cursor Rule that activates when you mention `@congruence`
- 5-step Gate Function before any claim/commit/PR
- No automatic enforcement — Cursor has no Stop hook equivalent

## Quick install

```bash
cd your-project/
mkdir -p .cursor/rules
curl -L https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/cursor/congruence.mdc \
  -o .cursor/rules/congruence.mdc
```

Or clone the whole skill:

```bash
git clone https://github.com/brunnocarpena/congruence-skill.git /tmp/congruence-skill
mkdir -p .cursor/rules
cp /tmp/congruence-skill/adapters/cursor/congruence.mdc .cursor/rules/
```

## How to invoke

In Cursor chat:

```
@congruence audit the changes I'm about to commit
```

Or include in any prompt where you're about to ship work:

```
Implement feature X. Before declaring done, follow @congruence.
```

## Limitations vs Claude Code

- **No Stop hook** — Cursor cannot auto-trigger the audit at end of turn. You must mention `@congruence`.
- **No Task tool** — to dispatch an independent auditor, open a new Cursor chat session and paste the [auditor-prompt](https://github.com/brunnocarpena/congruence-skill/blob/main/auditor-prompt.md).
- **`globs` field** restricts where the rule applies — adjust the frontmatter glob list to match your project's user-facing paths.

## Updating

```bash
curl -L https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/cursor/congruence.mdc \
  -o .cursor/rules/congruence.mdc
```

## Reference

- Cursor Rules docs: https://docs.cursor.com/context/rules
