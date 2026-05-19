# congruence-skill

> **Semantic congruence auditing for AI coding agents.** Verifies that what an AI agent says, writes, or documents actually matches what the project does. Not technical code review — checks whether claims about the code are true.

🇺🇸 · [🇧🇷](README.pt-BR.md) · [🇪🇸](README.es.md) · [🇫🇷](README.fr.md) · [🇩🇪](README.de.md) · [🇨🇳](README.zh.md)

---

## What it is

AI coding agents hallucinate. They generate code that looks correct but describes things that don't exist, write README files unaligned with the actual code, or invent integrations. This skill audits that class of error — **semantic incongruence**.

**Core principle:** No claim about the project is true without evidence in the project itself.

## What it catches

Any divergence between what the agent (or the project's docs, UI, copy, configs) **claims** and what the code **actually does** — across any domain, stack, or language. Wherever a statement can be verified against source, `congruence` checks it.

A few illustrative examples (non-exhaustive): an FAQ describing a 3-step flow that's actually 5; a README documenting price $49 while Stripe charges $79; a landing announcing a "Stripe integration" that is only a `// TODO`; setup asking for Node 18 when the project requires Node 20; "123 active leads" counting deleted ones; a CTA "Get free spot" leading to a $497 checkout; a function renamed in 1 file with 47 callsites broken; a doc claiming a feature exists when only a mock returns `success`.

All of this **passes any technical code review** because the code compiles and runs. `congruence` is the barrier against this class of bug.

## Supported AI platforms

| Platform | Adapter | Status |
|----------|---------|--------|
| **Claude Code** (CLI / IDE / web) | root `SKILL.md` | ✅ Primary |
| **Cursor** | [`adapters/cursor/`](adapters/cursor/) | ✅ Supported |
| **GitHub Copilot** | [`adapters/copilot/`](adapters/copilot/) | ✅ Supported |
| **Gemini CLI / Antigravity** | [`adapters/gemini/`](adapters/gemini/) | ✅ Supported |
| **OpenAI Codex CLI** | [`adapters/codex/`](adapters/codex/) | ✅ Supported |
| **Aider** | [`adapters/aider/`](adapters/aider/) | ✅ Supported |
| **Qwen Code CLI** (Alibaba) | [`adapters/qwen/`](adapters/qwen/) | ✅ Supported |
| **Kimi K2** (Moonshot AI) | [`adapters/kimi/`](adapters/kimi/) | ✅ Supported |
| **Windsurf** (Codeium) | [`adapters/windsurf/`](adapters/windsurf/) | ✅ Supported |
| **Cline** (VS Code) | [`adapters/cline/`](adapters/cline/) | ✅ Supported |
| **Continue.dev** | [`adapters/continue/`](adapters/continue/) | ✅ Supported |
| **Zed Editor** | [`adapters/zed/`](adapters/zed/) | ✅ Supported |
| **JetBrains Junie** | [`adapters/jetbrains-junie/`](adapters/jetbrains-junie/) | ✅ Supported |
| **Sourcegraph Cody** | [`adapters/cody/`](adapters/cody/) | ✅ Supported |
| **ChatGPT Custom GPT** | [`adapters/chatgpt-custom-gpt/`](adapters/chatgpt-custom-gpt/) | ✅ Supported |
| **Generic LLM** (ChatGPT.com, Claude.ai, any chat) | [`adapters/generic-prompt/`](adapters/generic-prompt/) | ✅ Supported |
Each adapter has its own `INSTALL.md` with platform-specific steps.

## Quick install (Claude Code)

```bash
# Project-local (recommended)
cd your-project/
mkdir -p .claude/skills
git clone https://github.com/xBelowZero/congruence-skill.git .claude/skills/congruence

# Or global (all projects)
mkdir -p ~/.claude/skills
git clone https://github.com/xBelowZero/congruence-skill.git ~/.claude/skills/congruence
```

Invoke in a session: `/congruence` or "audit congruence of this session's work".

For other platforms, see the relevant `adapters/<platform>/INSTALL.md`.

## How it works

1. Identifies files changed in the session
2. Extracts verifiable claims from agent output
3. Searches for evidence in source-of-truth hierarchy
4. Classifies each claim: `congruent` / `incongruent` / `partial` / `unverifiable`
5. Generates structured report
6. Issues pre-deploy decision

Full workflow: [SKILL.md](SKILL.md).

## Difference vs. other skills

| Skill | What it checks |
|-------|---------------|
| `congruence` | Semantic truth: do claims match code? |
| `verification-before-completion` | Code works: tests pass, build succeeds |
| `requesting-code-review` | Technical quality: bugs, patterns, maintainability |
| `systematic-debugging` | Root cause of reproducible bugs |

Skills are complementary. `congruence` occupies the niche of **drift between what is said and what code does** — gap not covered by the others.

## Repository structure

```
congruence-skill/
├── SKILL.md                   # Workflow + Iron Law + tables (EN primary)
├── SKILL.pt-BR.md             # Portuguese (Brazil)
├── SKILL.es.md                # Spanish
├── SKILL.fr.md                # French
├── SKILL.de.md                # German
├── SKILL.zh.md                # Chinese
├── README.md / .pt-BR / .es / .fr / .de / .zh
├── auditor-prompt.md          # Template for subagent dispatch (+ translations)
├── checks/                    # Progressive disclosure by domain
│   ├── docs.md                #   README, CHANGELOG, /docs
│   ├── ui-copy.md             #   labels, buttons, headlines
│   ├── data-numbers.md        #   prices, dates, counts
│   ├── integrations.md        #   Stripe, OAuth, webhooks
│   └── features-flows.md      #   announced features and flows
├── references/                # Deep guides
├── examples/                  # Case studies
├── hooks/                     # OPTIONAL: Claude Code auto-suggestion
├── adapters/                  # Other AI platforms
│   ├── cursor/
│   ├── github-copilot/
│   ├── gemini/
│   ├── openai-codex/
│   ├── aider/
│   └── generic-prompt/
└── scripts/
```

## Contributing

Issues and PRs welcome. Before opening a PR:

1. Read `SKILL.md` to understand the workflow
2. If adding a new type of check, consider whether it fits in `references/` or deserves its own file in `checks/`
3. Examples must be **generic** (not specific to stack X or framework Y)
4. Translations: keep all language versions in sync (PT-BR and EN are reference)

## License

MIT — see [LICENSE](LICENSE).

## Inspiration

Patterns and structure inspired by:
- [obra/superpowers](https://github.com/obra/superpowers) — especially `verification-before-completion` and `writing-skills`
- [anthropics/skills](https://github.com/anthropics/skills) — `skill-creator` and official best practices
- [Anthropic Agent Skills docs](https://docs.claude.com/en/docs/claude-code/skills)