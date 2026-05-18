---
name: congruence
description: Use whenever you are about to declare work complete, commit, open a PR, update README/CHANGELOG/docs, or ship a change that affects user-facing text — audits whether what the agent said, wrote, or documented actually matches what the code does. Use proactively before ANY completion claim. TRIGGER when the agent uses phrases like "now supports", "implemented", "works", "ready", "fixed", "added"; when modified files include README, CHANGELOG, docs/, help-center, FAQ, landing page, UI copy, or AI prompts; before release/deploy. SKIP when changes are formatting-only, dependency version bumps, internal refactors with no user-facing text touched, or test-only changes.
argument-hint: [scope?] [--dispatch-agent?]
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(scripts/scan-changed-files.sh:*), Task
---

# Congruence

Audits whether what the agent said, wrote, or documented matches what the code actually does. **This is not technical code review.** It is an audit of **semantic truth**.

**Core principle:** No claim about the project is true without evidence in the project itself.

**Violating the letter of this rule is violating the spirit of it.** Text the agent just generated is never a source of truth — not even with hedges like "probably", "should be", "I assumed that".

## The Iron Law

```
NO USER-FACING CLAIM WITHOUT GROUND-TRUTH EVIDENCE
```

If you wrote "the app now does X" and you cannot point to the file/test/route that proves X, you **cannot** publish that claim. Downgrade it to "planned", "partial", or remove it.

## Gate Function — before any claim or doc edit

Execute in order. Each step blocks the next if incomplete.

1. **EXTRACT** — list every concrete claim in the output ("supports X", "fixed Y", "now displays Z"). See [references/claim-extraction-guide.md](references/claim-extraction-guide.md) if you need techniques.
2. **MAP** — for each claim, point to file:line/test/route that proves it. No target? Mark as `unverifiable`.
3. **AUDIT** — for each unproven claim: **delete** or **downgrade** to "planned/partial/in-progress".
4. **CROSS-CHECK** — ensure terminology in docs matches code (function names, env vars, routes, labels).
5. **EMIT** — only now generate the message/commit/PR/release notes.

## Evidence table by claim type

| Claim | Requires | Not sufficient |
|-------|----------|----------------|
| "Now supports X" | Passing test + greppable function/route name | "Added a TODO", "scaffolding exists" |
| "Fixed bug Y" | Failing test → passing test (red-green) | "Code changed, looks correct" |
| "README says X" | grep README + grep code, both contain X | README edit alone |
| "Renamed Y to Z" | grep entire repo: 0 occurrences of Y | Renamed in 1 file |
| "Removed feature W" | grep code + README + tests → 0 occurrences | Removed from code only |
| "Integrates with Stripe/X" | Code + env var + handler/webhook configured | mock or `// TODO: integrate Stripe` |
| "Price/date/number X" | grep the literal value in source (config, db seed, or hard-coded) | Number appears only in generated copy |
| "Has X options in select" | Component lists exactly X items, not mock | "should have around X options" |

Deeper guide: [references/source-of-truth-priority.md](references/source-of-truth-priority.md)

## Red Flags — STOP

If you catch yourself thinking or writing:

- "should work", "probably is", "I assumed that", "it's implicit"
- Writing README **before** the code (or after, without re-reading the code)
- Pasting an LLM-generated PR description without grep
- "I'll mention X in the docs, the user figures out the exact spelling"
- Renaming a function without grep across the entire repo
- Status report includes a feature implemented "earlier in the session" without re-verifying
- `package.json`/`README` describe something different from what the entry point actually does
- Marketing/landing copy promises a benefit with no code behind it

→ STOP. Return to step 1 of the Gate Function.

## Excuse | Reality table

| Excuse | Reality |
|--------|---------|
| "The user fixes the README later" | A published claim = a made claim. Verify or remove. |
| "Close enough" | Close ≠ true. Code is binary, claim is too. |
| "It's just docs" | Docs **are** the product for downstream agents. |
| "The intent is clear" | Intent ≠ implementation. Audit the implementation. |
| "I'm describing the design, not current state" | Then say "planned", don't use present tense. |
| "Spirit of the change is right" | The letter IS the spirit. Audit the actual diff. |
| "Just this once" | There is no just-this-once. Every claim gets audited. |

## Workflow

### 1. Identify scope

```bash
bash scripts/scan-changed-files.sh
```

Or use git diff directly. List files created/modified in the session.

If `$ARGUMENTS` contains a specific scope (e.g. `/congruence headlines`, `/congruence pricing`), filter only files/areas matching the scope.

### 2. Extract claims

Read each session output and each modified file. Transform implicit and explicit statements into objective claims. Guide: [references/claim-extraction-guide.md](references/claim-extraction-guide.md).

### 3. Search for evidence

For each claim, look for the source of truth in the hierarchy (executable > routes/handlers > schemas > tests > config > UI > mocks > docs > README > comments > agent text).

### 4. Classify

| Status | Meaning |
|--------|---------|
| `congruent` | Evidence confirms |
| `incongruent` | Evidence contradicts |
| `partially congruent` | Part correct, important omissions |
| `unverifiable` | Insufficient evidence |

Severity: [references/severity-rubric.md](references/severity-rubric.md).

### 5. Report

Mandatory template: [references/report-format.md](references/report-format.md).

### 6. Pre-deploy decision

- Any `critical` → **do not approve**
- Unresolved `high` → **do not approve**
- Many `unverifiable` in essential areas → **require manual review**
- Only `medium`/`low` → **approve with caveats**
- All `congruent` → **approve**

## Auditor subagent dispatch (optional)

When scope is large (full-page audit, long release notes, multiple areas), the current agent may be biased from generating the claims. **Dispatching a fresh subagent avoids self-confirmation.**

**When to ask the user about dispatch:**
- More than 5 claims to audit
- Changes touch 3+ distinct domains (docs + UI + integrations, for example)
- Release notes or PR description longer than 200 lines
- User said "audit everything" without specifying scope

**How to ask:**

> "I detected N claims across M areas. Would you like me to dispatch a specialist subagent to audit in parallel? (yes/no/just this part)"

**If user accepts** (or if invoked with `/congruence --dispatch-agent`):
- Use the Task tool with the template in [auditor-prompt.md](auditor-prompt.md)
- Pass scope, extracted claim list, and base/head SHAs
- Await the structured report and consolidate into the final decision

**If running inline**: continue with the workflow above.

> **Hidden cost**: each subagent reloads CLAUDE.md + all skill descriptions. Dispatch is expensive for small audits. Default is inline.

## When NOT to use

- Technical code review (bugs, performance, security) → use `requesting-code-review`
- Verifying that code compiles / tests pass → use `verification-before-completion`
- Linting, formatting
- Isolated unit-test review

## Related skills

- **superpowers:verification-before-completion** — verifies that the **code works** (tests, build). `congruence` verifies that the **claims about the code** match the code. Use both before any release.
- **superpowers:systematic-debugging** — when a congruence audit reveals "code does X but docs say Y", debug systematically instead of just patching the doc.
- **superpowers:requesting-code-review** — technical quality. Complementary, not a replacement.

## Why this matters

Agents hallucinate. Technical code review doesn't catch this because the code is correct — what is wrong is the **information about the code**.

Real examples:
- FAQ describes a 3-step flow when it's actually 5
- README documents price $49 but Stripe charges $79
- Landing page announces WhatsApp integration that doesn't exist
- Setup asks for Node 18 but project requires Node 20
- "123 active leads" counts deleted leads
- CTA says "Claim your free spot" and leads to a $497 checkout
- Headline in EN, form in ES (mixed languages)
- Date "May 17 2026" in hero, "05/17/2025" in footer

All of this **passes technical code review** because the code compiles and runs. `congruence` is the barrier against this type of error.

## Inviolable rules

1. Text the agent just generated is **never** a source of truth
2. Plausibility is **not** proof — concrete evidence required
3. No evidence → `unverifiable`, **never** `congruent`
4. `critical`/`high` issues **block** deploy/merge
5. Report generated **always**, even if everything is `congruent`
6. **Violating the letter is violating the spirit** — no exceptions, no "just this once"

---

**Languages:** 🇺🇸 English · [🇧🇷 Português](SKILL.pt-BR.md) · [🇪🇸 Español](SKILL.es.md) · [🇫🇷 Français](SKILL.fr.md) · [🇩🇪 Deutsch](SKILL.de.md) · [🇨🇳 中文](SKILL.zh.md)