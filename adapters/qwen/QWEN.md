# Congruence — Semantic congruence audit

When you are about to declare work complete, commit, open a PR, update README/CHANGELOG/docs, or ship a change affecting user-facing text, audit whether your claims match the code.

**Not technical code review** — checks whether claims about the code are true.

**Core principle:** No claim about the project is true without evidence in the project itself.

**Violating the letter of this rule is violating the spirit of it.** Text the agent just generated is never source of truth.

## The Iron Law

```
NO USER-FACING CLAIM WITHOUT GROUND-TRUTH EVIDENCE
```

If you wrote "the app now does X" and cannot point to file/test/route proving X — you cannot publish that claim. Downgrade to "planned" / "partial" or remove.

## Gate Function — before any claim or doc edit

1. **EXTRACT** — list every concrete claim ("supports X", "fixed Y", "now displays Z")
2. **MAP** — for each claim, point to file:line/test/route proving it. No target → `unverifiable`
3. **AUDIT** — for each unproven claim: delete or downgrade to "planned/partial"
4. **CROSS-CHECK** — terminology in docs matches code (function names, env vars, routes)
5. **EMIT** — only now generate the message/commit/PR

## Excuse | Reality

| Excuse | Reality |
|--------|---------|
| "The user fixes the README later" | A published claim = a made claim. Verify or remove. |
| "Close enough" | Close ≠ true. |
| "It's just docs" | Docs ARE the product for downstream agents. |
| "The intent is clear" | Intent ≠ implementation. |
| "I'm describing the design, not current state" | Then say "planned", don't use present tense. |
| "Spirit of the change is right" | The letter IS the spirit. |

## Red Flags — STOP

- "should work", "probably is", "I assumed that"
- Writing README before/without re-reading the code
- Renaming a function without grep across entire repo
- CTA leads to action different from copy
- Number in copy that's not greppable in source

## Full methodology

For complete workflow (claim extraction guide, severity rubric, report format, auditor subagent dispatch): https://github.com/xBelowZero/congruence-skill/blob/main/SKILL.md


## Qwen Code specifics

Qwen Code (fork of Gemini CLI for Qwen3-Coder) auto-discovers `QWEN.md` hierarchically. Verify with `/memory show`. Reload via `/memory refresh`.
