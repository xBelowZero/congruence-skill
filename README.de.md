# congruence-skill

> **Semantisches Congruence-Auditing für KI-Coding-Agenten.** Verifiziert, ob das, was ein KI-Agent sagt, schreibt oder dokumentiert, tatsächlich dem entspricht, was das Projekt tut. Kein technisches Code Review — prüft, ob Behauptungen über den Code wahr sind.

**Sprachen:** [🇺🇸 English](README.md) · [🇧🇷 Português](README.pt-BR.md) · [🇪🇸 Español](README.es.md) · [🇫🇷 Français](README.fr.md) · 🇩🇪 Deutsch · [🇨🇳 中文](README.zh.md)

---

## Was es ist

KI-Coding-Agenten halluzinieren. Sie generieren Code, der korrekt aussieht, aber Dinge beschreibt, die nicht existieren, schreiben READMEs, die nicht zum echten Code passen, oder erfinden Integrationen. Diese Skill auditiert diese Fehlerklasse — **semantische Inkongruenz**.

**Kernprinzip:** Keine Behauptung über das Projekt ist wahr ohne Beweis im Projekt selbst.

## Was sie abfängt

- FAQ beschreibt 3-Schritt-Flow, der tatsächlich 5 Schritte hat
- README dokumentiert Preis 49 €, aber Stripe berechnet 79 €
- Landing kündigt "Stripe-Integration" an, die nur ein `// TODO` ist
- Setup fordert Node 18, Projekt verlangt aber Node 20
- "123 aktive Leads" zählt gelöschte Leads mit
- CTA "Sichern Sie sich Ihren kostenlosen Platz" führt zu 497-€-Checkout
- Funktion in 1 Datei umbenannt, 47 Aufruf-Stellen kaputt
- Doc sagt Feature existiert, nur ein Mock gibt `success` zurück

All das **besteht jedes technische Code Review**, weil der Code kompiliert und läuft. `congruence` ist die Barriere gegen diese Bug-Klasse.

## Unterstützte KI-Plattformen

| Plattform | Adapter | Status |
|-----------|---------|--------|
| **Claude Code** (CLI / IDE / web) | root `SKILL.md` | ✅ Primär |
| **Cursor** | [`adapters/cursor/`](adapters/cursor/) | ✅ Unterstützt |
| **GitHub Copilot CLI** | [`adapters/github-copilot/`](adapters/github-copilot/) | ✅ Unterstützt |
| **Gemini CLI / Antigravity** | [`adapters/gemini/`](adapters/gemini/) | ✅ Unterstützt |
| **OpenAI Codex CLI** | [`adapters/openai-codex/`](adapters/openai-codex/) | ✅ Unterstützt |
| **Aider** | [`adapters/aider/`](adapters/aider/) | ✅ Unterstützt |
| **Qwen Code CLI** | [`adapters/qwen/`](adapters/qwen/) | ✅ Unterstützt |
| **Kimi K2** | [`adapters/kimi/`](adapters/kimi/) | ✅ Unterstützt |
| **Windsurf** (Codeium) | [`adapters/windsurf/`](adapters/windsurf/) | ✅ Unterstützt |
| **Cline** (VS Code) | [`adapters/cline/`](adapters/cline/) | ✅ Unterstützt |
| **Continue.dev** | [`adapters/continue/`](adapters/continue/) | ✅ Unterstützt |
| **Zed Editor** | [`adapters/zed/`](adapters/zed/) | ✅ Unterstützt |
| **JetBrains Junie** | [`adapters/jetbrains-junie/`](adapters/jetbrains-junie/) | ✅ Unterstützt |
| **Sourcegraph Cody** | [`adapters/cody/`](adapters/cody/) | ✅ Unterstützt |
| **ChatGPT Custom GPT** | [`adapters/chatgpt-custom-gpt/`](adapters/chatgpt-custom-gpt/) | ✅ Unterstützt |
| **Generisches LLM** (beliebige Chat-UI) | [`adapters/generic-prompt/`](adapters/generic-prompt/) | ✅ Unterstützt |

Jeder Adapter hat sein eigenes `INSTALL.md` mit plattform-spezifischen Schritten.

## Schnellinstallation (Claude Code)

```bash
# Projekt-lokal (empfohlen)
cd ihr-projekt/
mkdir -p .claude/skills
git clone https://github.com/xBelowZero/congruence-skill.git .claude/skills/congruence

# Oder global (alle Projekte)
mkdir -p ~/.claude/skills
git clone https://github.com/xBelowZero/congruence-skill.git ~/.claude/skills/congruence
```

Aufruf in einer Session: `/congruence` oder "auditiere die Congruence der Arbeit dieser Session".

Für andere Plattformen siehe das relevante `adapters/<plattform>/INSTALL.md`.

## Lizenz

MIT — siehe [LICENSE](LICENSE).

<!-- TRANSLATION NOTE: AI-generated. Native speaker review recommended. -->
