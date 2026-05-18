# Install congruence on Sourcegraph Cody

> Cody has no `.cody/rules/` convention — congruence is installed as a **saved Prompt** in Cody's Prompt Library, invoked manually.

## What you get

- Manually-invoked `/congruence` command in Cody Chat
- 5-step Gate Function on demand
- Workspace alternative via `.vscode/cody.json`

## Quick install (Prompt Library, recommended)

1. Open Sourcegraph instance → Cody panel → Prompt Library
2. Create new prompt:
   - Name: `congruence`
   - Description: `Audit semantic congruence between claims and code`
   - Definition: paste content of [`cody-prompt.md`](https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/cody/cody-prompt.md)
3. Save

## Quick install (workspace command, alternative)

Add to `.vscode/cody.json`:

```json
{
  "commands": {
    "congruence": {
      "description": "Audit semantic congruence",
      "prompt": "[paste cody-prompt.md content here]",
      "context": { "currentDir": true }
    }
  }
}
```

## How to invoke

In Cody Chat:

```
/congruence audit my recent changes before I commit
```

## Limitations vs Claude Code

- **No ambient activation** — must invoke explicitly each time.
- **No hooks, no Task tool**.
- **Prompt Library is per-instance** — share within your Sourcegraph organization.
- **No file system access from prompts** — Cody reads what's in chat context.

## Updating

Edit the saved prompt in Prompt Library with the latest content from [`cody-prompt.md`](https://raw.githubusercontent.com/xBelowZero/congruence-skill/main/adapters/cody/cody-prompt.md).

## Reference

- Cody Prompts: https://sourcegraph.com/docs/cody/capabilities/prompts
- Prompt Library: https://sourcegraph.com/blog/announcing-prompt-library
