# Install congruence as a ChatGPT Custom GPT

> Create a Custom GPT named "Congruence Auditor" — paste the prepared instructions into GPT Builder.

## What you get

- A dedicated ChatGPT GPT that audits your claims
- Available in your ChatGPT account anywhere (web, mobile, desktop)
- Optionally shareable with your team or public

## Quick install

1. Open https://chatgpt.com/gpts/editor
2. Tab "Configure"
3. Name: `Congruence Auditor`
4. Description: `Audits whether your claims about your project actually match the code`
5. Instructions field: paste the entire content of [`instructions.md`](https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/chatgpt-custom-gpt/instructions.md)
6. Conversation starters (optional):
   - "Audit my recent changes before I commit"
   - "Check this PR description against the code"
   - "I'm about to update the README — verify the claims"
7. Capabilities: enable **Code Interpreter** if you want it to run grep on uploaded files
8. Save → choose visibility (Only me / Anyone with link / Public)

## How to invoke

Open your GPT, paste:

```
I'm about to commit these changes: [paste diff].
Audit congruence.
```

Or upload files and ask:

```
Verify this README against the actual code in the uploaded files.
```

## Limitations vs Claude Code

- **~8000 char Instructions limit** — methodology trimmed to fit. Full version is the linked SKILL.md.
- **No file system access** unless Code Interpreter is enabled.
- **No hooks, no Task tool**.
- **OpenAI-only** — requires ChatGPT Plus/Team/Enterprise.

## Updating

Edit your GPT in the Builder and replace the Instructions with the latest [`instructions.md`](https://raw.githubusercontent.com/brunnocarpena/congruence-skill/main/adapters/chatgpt-custom-gpt/instructions.md).

## Reference

- GPT Builder: https://help.openai.com/en/articles/8554407-gpts-faq
- 8000 char limit confirmation: https://community.openai.com/t/how-can-i-increase-the-ceiling-for-gpt-instructions-beyond-8000-characters/801867
