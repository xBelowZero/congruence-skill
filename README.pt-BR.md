# congruence-skill

> **Auditoria de congruência semântica para agentes de IA.** Verifica se o que um agente AI diz, escreve ou documenta corresponde de fato ao que o projeto faz. Não é code review técnico — checa se as afirmações sobre o código são verdadeiras.

[🇺🇸](README.md) · 🇧🇷 · [🇪🇸](README.es.md) · [🇫🇷](README.fr.md) · [🇩🇪](README.de.md) · [🇨🇳](README.zh.md)

---

## O que é

Agentes AI alucinam. Geram código que parece correto mas descreve coisas que não existem, escrevem README desalinhado do código real, ou inventam integrações. Esta skill audita essa classe de erro — **incongruência semântica**.

**Princípio central:** Nenhuma afirmação sobre o projeto é verdadeira sem evidência no próprio projeto.

## O que pega

Qualquer divergência entre o que o agente (ou os docs, UI, copy e configs do projeto) **afirma** e o que o código **de fato faz** — em qualquer domínio, stack ou linguagem. Onde houver uma afirmação verificável contra o código-fonte, `congruence` checa.

Alguns exemplos ilustrativos (não exaustivos): FAQ descrevendo um fluxo de 3 passos quando na verdade são 5; README documentando preço R$49 enquanto o Stripe cobra R$79; landing anunciando "integração Stripe" que é só um `// TODO`; setup pedindo Node 18 quando o projeto exige Node 20; "123 leads ativos" contando deletados; CTA "Garanta seu lugar grátis" levando a checkout de R$497; função renomeada em 1 arquivo com 47 callsites quebrados; doc afirmando que uma feature existe quando só um mock retorna `success`.

Tudo isso **passa em qualquer code review técnico** porque o código compila e roda. `congruence` é a barreira contra essa classe de bug.

## Plataformas AI suportadas

| Plataforma | Adapter | Status |
|------------|---------|--------|
| **Claude Code** (CLI / IDE / web) | `SKILL.md` raiz | ✅ Primário |
| **Cursor** | [`adapters/cursor/`](adapters/cursor/) | ✅ Suportado |
| **GitHub Copilot** | [`adapters/copilot/`](adapters/copilot/) | ✅ Suportado |
| **Gemini CLI / Antigravity** | [`adapters/gemini/`](adapters/gemini/) | ✅ Suportado |
| **OpenAI Codex CLI** | [`adapters/codex/`](adapters/codex/) | ✅ Suportado |
| **Aider** | [`adapters/aider/`](adapters/aider/) | ✅ Suportado |
| **Qwen Code CLI** (Alibaba) | [`adapters/qwen/`](adapters/qwen/) | ✅ Suportado |
| **Kimi K2** (Moonshot AI) | [`adapters/kimi/`](adapters/kimi/) | ✅ Suportado |
| **Windsurf** (Codeium) | [`adapters/windsurf/`](adapters/windsurf/) | ✅ Suportado |
| **Cline** (VS Code) | [`adapters/cline/`](adapters/cline/) | ✅ Suportado |
| **Continue.dev** | [`adapters/continue/`](adapters/continue/) | ✅ Suportado |
| **Zed Editor** | [`adapters/zed/`](adapters/zed/) | ✅ Suportado |
| **JetBrains Junie** | [`adapters/jetbrains-junie/`](adapters/jetbrains-junie/) | ✅ Suportado |
| **Sourcegraph Cody** | [`adapters/cody/`](adapters/cody/) | ✅ Suportado |
| **ChatGPT Custom GPT** | [`adapters/chatgpt-custom-gpt/`](adapters/chatgpt-custom-gpt/) | ✅ Suportado |
| **LLM genérico** (ChatGPT.com, Claude.ai, qualquer chat) | [`adapters/generic-prompt/`](adapters/generic-prompt/) | ✅ Suportado |

Cada adapter tem seu próprio `INSTALL.md` com passos específicos por plataforma.

## Instalação rápida (Claude Code)

```bash
# Projeto local (recomendado)
cd seu-projeto/
mkdir -p .claude/skills
git clone https://github.com/xBelowZero/congruence-skill.git .claude/skills/congruence

# Ou global (todos os projetos)
mkdir -p ~/.claude/skills
git clone https://github.com/xBelowZero/congruence-skill.git ~/.claude/skills/congruence
```

Invoque numa sessão: `/congruence` ou "audite a congruência do trabalho desta sessão".

Para outras plataformas, veja o `adapters/<plataforma>/INSTALL.md` correspondente.

## Como funciona

1. Identifica arquivos modificados na sessão
2. Extrai claims verificáveis dos outputs do agente
3. Busca evidência na hierarquia de fontes de verdade
4. Classifica cada claim: `congruent` / `incongruent` / `partial` / `unverifiable`
5. Gera relatório estruturado
6. Emite decisão pré-deploy

Workflow completo: [SKILL.md](SKILL.md).

## Diferença vs. outras skills

| Skill | O que verifica |
|-------|----------------|
| `congruence` | Verdade semântica: claims batem com o código? |
| `verification-before-completion` | Código funciona: testes passam, build sobe |
| `requesting-code-review` | Qualidade técnica: bugs, padrões, manutenibilidade |
| `systematic-debugging` | Root cause de bugs reproduzíveis |

Skills são complementares. `congruence` ocupa o nicho de **drift entre o que se diz e o que o código faz** — lacuna não coberta pelas demais.

## Estrutura do repositório

```
congruence-skill/
├── SKILL.md                   # Workflow + Iron Law + tabelas (EN primário)
├── SKILL.pt-BR.md             # Português (Brasil)
├── SKILL.es.md                # Espanhol
├── SKILL.fr.md                # Francês
├── SKILL.de.md                # Alemão
├── SKILL.zh.md                # Chinês
├── README.md / .pt-BR / .es / .fr / .de / .zh
├── auditor-prompt.md          # Template pra dispatch de subagente (+ traduções)
├── checks/                    # Progressive disclosure por domínio
│   ├── docs.md                #   README, CHANGELOG, /docs
│   ├── ui-copy.md             #   labels, botões, headlines
│   ├── data-numbers.md        #   preços, datas, contagens
│   ├── integrations.md        #   Stripe, OAuth, webhooks
│   └── features-flows.md      #   features e fluxos anunciados
├── references/                # Guias profundos
├── examples/                  # Estudos de caso
├── hooks/                     # OPCIONAL: auto-suggestion no Claude Code
├── adapters/                  # Outras plataformas AI
│   ├── cursor/
│   ├── github-copilot/
│   ├── gemini/
│   ├── openai-codex/
│   ├── aider/
│   └── generic-prompt/
└── scripts/
```

## Contribuindo

Issues e PRs bem-vindos. Antes de abrir PR:

1. Leia `SKILL.md` pra entender o workflow
2. Se for adicionar tipo novo de check, considere se cabe em `references/` ou merece arquivo próprio em `checks/`
3. Examples devem ser **genéricos** (não específicos de stack X ou framework Y)
4. Traduções: mantenha todas as versões de idioma em sync (PT-BR e EN são referência)

## Licença

MIT — veja [LICENSE](LICENSE).

## Inspiração

Padrões e estrutura inspirados em:
- [obra/superpowers](https://github.com/obra/superpowers) — especialmente `verification-before-completion` e `writing-skills`
- [anthropics/skills](https://github.com/anthropics/skills) — `skill-creator` e best practices oficiais
- [Anthropic Agent Skills docs](https://docs.claude.com/en/docs/claude-code/skills)