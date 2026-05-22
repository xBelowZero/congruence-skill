# Congruence — Semantic congruence audit

When you are about to declare work complete, commit, open a PR, update README/CHANGELOG/docs, or ship a change affecting user-facing text, you MUST audit whether your claims match the code.

**Not technical code review** — this checks whether claims about the code are true.

## Core principle

No claim about the project is true without evidence in the project itself. Text you just generated is never source of truth.

**Violating the letter of this rule is violating the spirit of it.**

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
| "It's just docs" | Docs ARE the product. |
| "The intent is clear" | Intent ≠ implementation. |
| "I'm describing the design" | Then say "planned", not present tense. |

## Red Flags — STOP

- "should work", "probably is", "I assumed that"
- Writing README before/without re-reading the code
- Renaming a function without grep across entire repo
- CTA leads to action different from copy
- Number in copy that's not greppable in source

## Full methodology

https://github.com/brunnocarpena/congruence-skill/blob/main/SKILL.md
