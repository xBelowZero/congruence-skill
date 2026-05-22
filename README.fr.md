# Congruence — Audit de Vérité Sémantique pour Agents IA de Code

> **Audit de congruence sémantique pour agents de codage IA.** Vérifie si ce qu'un agent IA dit, écrit ou documente correspond réellement à ce que fait le projet. Pas une revue de code technique — vérifie si les affirmations sur le code sont vraies.

[🇺🇸](README.md) · [🇧🇷](README.pt-BR.md) · [🇪🇸](README.es.md) · 🇫🇷 · [🇩🇪](README.de.md) · [🇨🇳](README.zh.md)

---

## Ce que c'est

Les agents de codage IA hallucinent. Ils génèrent du code qui semble correct mais décrit des choses qui n'existent pas, écrivent des README désalignés avec le code réel, ou inventent des intégrations. Cette skill audite cette classe d'erreur — l'**incongruence sémantique**.

**Principe central :** Aucune affirmation sur le projet n'est vraie sans preuve dans le projet lui-même.

## Ce qu'elle attrape

Toute divergence entre ce que l'agent (ou les docs, l'UI, la copy et les configs du projet) **affirme** et ce que le code **fait réellement** — dans n'importe quel domaine, stack ou langage. Partout où une affirmation peut être vérifiée par rapport au code source, `congruence` la contrôle.

Quelques exemples illustratifs (non exhaustifs) : une FAQ décrivant un flow en 3 étapes alors qu'il en compte 5 ; un README documentant un prix de 49 € alors que Stripe facture 79 € ; une landing annonçant une "intégration Stripe" qui n'est qu'un `// TODO` ; un setup exigeant Node 18 quand le projet requiert Node 20 ; "123 leads actifs" comptant les leads supprimés ; un CTA "Obtenez votre place gratuite" menant à un checkout à 497 € ; une fonction renommée dans 1 fichier avec 47 callsites cassés ; une doc affirmant qu'une fonctionnalité existe alors que seul un mock retourne `success`.

Tout cela **passe n'importe quelle revue de code technique** parce que le code compile et fonctionne. `congruence` est la barrière contre cette classe de bug.

## Plateformes IA supportées

| Plateforme | Adapter | Statut |
|------------|---------|--------|
| **Claude Code** (CLI / IDE / web) | `SKILL.md` racine | ✅ Principal |
| **Cursor** | [`adapters/cursor/`](adapters/cursor/) | ✅ Supporté |
| **GitHub Copilot CLI** | [`adapters/github-copilot/`](adapters/github-copilot/) | ✅ Supporté |
| **Gemini CLI / Antigravity** | [`adapters/gemini/`](adapters/gemini/) | ✅ Supporté |
| **OpenAI Codex CLI** | [`adapters/openai-codex/`](adapters/openai-codex/) | ✅ Supporté |
| **Aider** | [`adapters/aider/`](adapters/aider/) | ✅ Supporté |
| **Qwen Code CLI** | [`adapters/qwen/`](adapters/qwen/) | ✅ Supporté |
| **Kimi K2** | [`adapters/kimi/`](adapters/kimi/) | ✅ Supporté |
| **Windsurf** (Codeium) | [`adapters/windsurf/`](adapters/windsurf/) | ✅ Supporté |
| **Cline** (VS Code) | [`adapters/cline/`](adapters/cline/) | ✅ Supporté |
| **Continue.dev** | [`adapters/continue/`](adapters/continue/) | ✅ Supporté |
| **Zed Editor** | [`adapters/zed/`](adapters/zed/) | ✅ Supporté |
| **JetBrains Junie** | [`adapters/jetbrains-junie/`](adapters/jetbrains-junie/) | ✅ Supporté |
| **Sourcegraph Cody** | [`adapters/cody/`](adapters/cody/) | ✅ Supporté |
| **ChatGPT Custom GPT** | [`adapters/chatgpt-custom-gpt/`](adapters/chatgpt-custom-gpt/) | ✅ Supporté |
| **LLM générique** (toute chat UI) | [`adapters/generic-prompt/`](adapters/generic-prompt/) | ✅ Supporté |

Chaque adapter a son propre `INSTALL.md` avec étapes spécifiques à la plateforme.

## Installation rapide (Claude Code)

```bash
# Project-local (recommandé)
cd votre-projet/
mkdir -p .claude/skills
git clone https://github.com/brunnocarpena/congruence-skill.git .claude/skills/congruence

# Ou global (tous les projets)
mkdir -p ~/.claude/skills
git clone https://github.com/brunnocarpena/congruence-skill.git ~/.claude/skills/congruence
```

Invoquez dans une session : `/congruence` ou "audite la congruence du travail de cette session".

Pour les autres plateformes, voir l'`adapters/<plateforme>/INSTALL.md` pertinent.

## Comment ça marche

1. Identifie les fichiers modifiés dans la session
2. Extrait les affirmations vérifiables de l'output de l'agent
3. Cherche des preuves dans la hiérarchie source-of-truth
4. Classifie chaque affirmation : `congruent` / `incongruent` / `partiel` / `non vérifiable`
5. Génère un rapport structuré
6. Émet une décision pré-deploy

Workflow complet : [SKILL.md](SKILL.md).

## Licence

MIT — voir [LICENSE](LICENSE).

## Inspirations

- [obra/superpowers](https://github.com/obra/superpowers) — notamment `verification-before-completion` et `writing-skills`
- [anthropics/skills](https://github.com/anthropics/skills) — `skill-creator` et best practices officielles
- [Anthropic Agent Skills docs](https://docs.claude.com/en/docs/claude-code/skills)
