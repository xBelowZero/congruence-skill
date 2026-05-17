# congruence

> Claude Code skill for **semantic congruence auditing** — verifies that what an agent says, writes, or documents actually matches what the project does.

Skill em português para auditoria de congruência semântica entre os outputs de agentes AI e a realidade do projeto. **Não é code review técnico.** Verifica se o que foi dito, escrito, documentado ou exibido corresponde ao que o projeto realmente faz.

---

## O que é

Agentes AI alucinam, geram código que parece correto mas descreve algo que não existe, ou escrevem documentação desalinhada do código real. `congruence` é uma skill que audita esse tipo de erro — o que chamamos de **incongruência semântica**.

**Princípio central:**

> Nenhuma afirmação sobre o projeto é verdadeira sem evidência no próprio projeto. Se a única evidência é o texto que o agente acabou de escrever, o item é `não verificável`, nunca `congruente`.

## Quando usar

- Antes de fazer commit/merge de mudanças que envolvem texto user-facing, documentação ou UI
- Depois que um agente AI gerou FAQ, README, copy de landing page, ou documentação técnica
- Antes de deploy de qualquer feature nova
- Quando você desconfia que o agente "inventou" um comportamento que não está no código
- Para auditar drift entre documentação e implementação após refactors

## Quando **não** usar

- Code review técnico (bugs, performance, segurança) — use outras skills
- Linting/formatação
- Revisão de testes unitários isoladamente

## Instalação

### Como skill de projeto (recomendado)

```bash
cd seu-projeto/
mkdir -p .claude/skills
git clone https://github.com/xBelowZero/congruence.git .claude/skills/congruence
```

### Como skill global (todos os projetos)

```bash
mkdir -p ~/.claude/skills
git clone https://github.com/xBelowZero/congruence.git ~/.claude/skills/congruence
```

### Como plugin de marketplace

Em breve. Por ora, use git clone.

## Uso

Em uma sessão Claude Code, invoque a skill:

```
/congruence
```

Ou peça em linguagem natural:

```
audite a congruência do que foi feito nesta sessão
```

A skill executa um workflow de 6 passos:

1. Identifica arquivos modificados na sessão
2. Extrai claims verificáveis dos outputs
3. Busca evidência nas fontes de verdade do projeto
4. Compara e classifica cada claim
5. Gera relatório estruturado
6. Emite decisão pré-deploy (aprovar / aprovar com ressalvas / não aprovar)

## Estrutura

```
congruence/
├── SKILL.md                          # Workflow + Iron Law + tabelas (gate function)
├── auditor-prompt.md                 # Template versionado pra dispatch via Task tool
├── checks/                           # Progressive disclosure por domínio
│   ├── README.md                     #   Roteamento (qual check carregar)
│   ├── docs.md                       #   README, CHANGELOG, /docs
│   ├── ui-copy.md                    #   labels, botões, mensagens, headlines
│   ├── data-numbers.md               #   preços, datas, contagens, percentuais
│   ├── integrations.md               #   Stripe, OAuth, webhooks, APIs externas
│   └── features-flows.md             #   features e fluxos anunciados
├── references/                       # Guias profundos
│   ├── source-of-truth-priority.md   #   11 níveis de fontes de verdade
│   ├── congruence-checklist.md       #   Checklist por natureza da claim
│   ├── severity-rubric.md            #   4 níveis de severidade
│   ├── claim-extraction-guide.md     #   5 técnicas de extração
│   └── report-format.md              #   Template do relatório
├── examples/                         # Reviews completas (estudos de caso)
│   ├── payment-system-review.md      #   Ex: Sistema de Pagamento Stripe
│   ├── api-documentation-review.md   #   Ex: API REST + Documentação
│   ├── onboarding-permissions-review.md  # Ex: Onboarding + Permissões
│   └── setup-config-review.md        #   Ex: Setup + Configuração
├── hooks/                            # OPCIONAL: auto-suggestion via harness
│   ├── INSTALL.md                    #   Como ativar
│   ├── hooks.example.json            #   Stop + PostToolUse
│   └── mark-edit.sh                  #   PostToolUse helper
└── scripts/
    └── scan-changed-files.sh         # Scanner git de arquivos modificados
```

## Auto-suggestion (opcional)

A skill funciona via invocação manual (`/congruence`). Para que o harness **sugira automaticamente** rodar `congruence` ao fim de turnos que tocaram README/docs/copy, veja [hooks/INSTALL.md](hooks/INSTALL.md).

Não está no ecossistema mainstream ainda — é diferencial real desta skill.

## Dispatch de subagente auditor

Quando o escopo da auditoria é grande (release notes longas, página inteira, múltiplas áreas), a skill pode dispatchar um **subagente fresco** via Task tool com o template em [auditor-prompt.md](auditor-prompt.md). Útil pra evitar viés de auto-confirmação do agente que gerou as claims.

Default é **inline** (mais barato). Opt-in via `/congruence --dispatch-agent` ou a skill perguntará automaticamente quando detectar escopo grande.

## Por que isso importa

Sem congruence review, um agente pode:

- Criar um FAQ que descreve um fluxo de 3 passos quando na verdade são 5
- Documentar um preço de R$49 quando o Stripe cobra R$79
- Anunciar integração com WhatsApp que não existe no código
- Escrever README com Node 18 quando o projeto exige Node 20
- Exibir "123 leads ativos" contando leads deletados

Esses erros passam em qualquer code review técnico porque o código está correto — o problema é que a **informação** está errada.

## Diferença vs. outras skills

| Skill | O que verifica |
|-------|---------------|
| `congruence` | Verdade semântica: claims batem com o código? |
| `verification-before-completion` (Superpowers) | Código funciona: testes passam, build sobe? |
| `requesting-code-review` (Superpowers) | Qualidade técnica: bugs, padrões, manutenibilidade |
| `systematic-debugging` (Superpowers) | Root cause de bugs reproduzíveis |

Skills são complementares. `congruence` ocupa o nicho de **drift entre o que se diz e o que o código faz** — lacuna não coberta pelas demais.

## Contribuindo

Issues e PRs bem-vindos. Antes de abrir PR:

1. Leia `SKILL.md` para entender o workflow
2. Se for adicionar tipo novo de check, considere se cabe em `references/` ou se merece arquivo próprio em `checks/`
3. Examples devem ser **genéricos** (não específicos de stack X ou framework Y)

## Licença

MIT — veja [LICENSE](LICENSE).

## Créditos e inspiração

Padrões e estrutura inspirados em:
- [obra/superpowers](https://github.com/obra/superpowers) — especialmente `verification-before-completion` e `writing-skills`
- [anthropics/skills](https://github.com/anthropics/skills) — `skill-creator` e best practices oficiais
- [Anthropic Agent Skills docs](https://docs.claude.com/en/docs/claude-code/skills)