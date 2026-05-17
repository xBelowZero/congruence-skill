# HANDOFF — Skill `congruence`

> Sessão: 2026-05-17 | Conversation ID: `2db18b26-d291-4148-8bd1-85dc46ced864`

---

## O que é

Claude Skill local e **confidencial** para auditoria de congruência semântica entre outputs de agentes AI e a realidade do projeto. Não é code review técnico — verifica se o que foi **dito, escrito, documentado ou exibido** corresponde ao que o projeto **realmente faz**.

**Localização:** `/Users/brunnocarpena/Documents/BMC MÍDIA/Windsurf/.claude/skills/congruence/`

**Princípio central:** "Nenhuma afirmação sobre o projeto é verdadeira sem evidência no próprio projeto."

---

## Estado atual

### ✅ Completo — Skill funcional com 11 arquivos

```
.claude/skills/congruence/
├── SKILL.md                                    # Core: 131 linhas, workflow de 6 passos
├── references/
│   ├── source-of-truth-priority.md             # 11 níveis de fontes de verdade
│   ├── congruence-checklist.md                 # Checklist por natureza da claim (7 categorias)
│   ├── severity-rubric.md                      # 4 níveis com exemplos concretos
│   ├── claim-extraction-guide.md               # 5 técnicas de extração de claims
│   └── report-format.md                        # Template obrigatório do relatório
├── examples/
│   ├── faq-congruence-review.md                # Conteúdo: Sistema de Pagamento (Stripe)
│   ├── landing-page-congruence-review.md       # Conteúdo: API REST + Documentação
│   ├── dashboard-congruence-review.md          # Conteúdo: Onboarding + Permissões
│   └── documentation-congruence-review.md      # Conteúdo: Setup + Configuração
└── scripts/
    └── scan-changed-files.sh                   # Scanner git de arquivos modificados
```

> **NOTA:** Os nomes dos arquivos em `examples/` ainda têm os nomes antigos (faq, landing-page, dashboard, documentation) mas o **conteúdo** foi completamente reescrito para cenários universais. Se necessário, renomear para: `payment-system-review.md`, `api-documentation-review.md`, `onboarding-permissions-review.md`, `setup-config-review.md`.

---

## O que foi feito nesta sessão

### Fase 1 — Pesquisa e Planejamento
- Pesquisou 10+ SKILL.md reais de skills populares no GitHub e Context7
- Analisou: `anthropics/skills` (136k★), `obra/superpowers` (195k★), `ComposioHQ/awesome-claude-skills` (60k★)
- Skills analisadas em detalhe: `using-superpowers`, `test-driven-development`, `writing-skills`, `verification-before-completion`, `systematic-debugging`, `requesting-code-review`, `brainstorming`, `executing-plans`, `skill-creator` (Anthropic oficial), `webapp-testing`
- Criou plano de implementação aprovado pelo usuário

### Fase 2 — Implementação v1
- Criou todos os 11 arquivos
- SKILL.md com frontmatter, workflow de 7 passos, estados de congruência, regras
- 5 references, 4 examples, 1 script

### Fase 3 — Refatoração v2 (pedido do usuário)
**Motivo:** Skill estava muito "amarrada" a tipos específicos (FAQ, LP, dashboard). Usuário queria algo genérico para auditar **qualquer task da sessão**.

**Mudanças aplicadas:**
1. **SKILL.md reescrito** — centrado em "qualquer output da sessão", não em tipos pré-definidos
2. **Description "pushy"** — padrão `skill-creator` Anthropic, lista muitos contextos de trigger
3. **Checklist refatorado** — por natureza da claim (fluxo, dados, funcionalidade, valores, integrações, permissões, nomenclatura) em vez de tipo de item
4. **4 exemplos reescritos** — cenários universais: pagamento Stripe, API REST, onboarding/permissões, setup/config
5. **Menos MUSTs, mais why** — seguindo conselho do `skill-creator`: "explain the why in lieu of heavy-handed musty MUSTs"
6. **Workflow reduzido** de 7 para 6 passos (mais enxuto)

---

## Decisões tomadas

| Decisão | Escolha | Justificativa |
|---------|---------|---------------|
| Localização | `.claude/skills/congruence/` no Windsurf | Padrão oficial para skills de projeto |
| Idioma | Português | Uso pessoal e confidencial |
| `disable-model-invocation` | `true` | Invocação apenas manual, evita falsos positivos |
| Abordagem genérica | Sim | Usuário pediu "geralzão" para qualquer task |
| Frontmatter description | "Use when..." + trigger conditions | CSO best practice do Superpowers `writing-skills` |
| Menos regras rígidas | Sim | Padrão `skill-creator` Anthropic |

---

## Padrões incorporados da pesquisa

| Padrão | Fonte |
|--------|-------|
| Progressive disclosure (3 níveis) | Anthropic oficial |
| CSO — description sem resumo de workflow | Superpowers `writing-skills` |
| Description "pushy" com muitos triggers | Anthropic `skill-creator` |
| Gate function (bloqueio pré-deploy) | Superpowers `verification-before-completion` |
| Evidence before claims | Superpowers `verification-before-completion` |
| Explain-the-why em vez de MUSTs | Anthropic `skill-creator` |
| Severity classification | Superpowers `code-review` |
| Rationalization prevention | Superpowers TDD |

---

## Pendências

### Obrigatório
1. **`chmod +x` no script** — não foi possível executar via terminal nesta sessão (workspace validation):
   ```bash
   chmod +x "/Users/brunnocarpena/Documents/BMC MÍDIA/Windsurf/.claude/skills/congruence/scripts/scan-changed-files.sh"
   ```

### Recomendado
2. **Renomear arquivos de exemplo** — nomes antigos não refletem o conteúdo novo:
   - `faq-congruence-review.md` → `payment-system-review.md`
   - `landing-page-congruence-review.md` → `api-documentation-review.md`
   - `dashboard-congruence-review.md` → `onboarding-permissions-review.md`
   - `documentation-congruence-review.md` → `setup-config-review.md`

3. **Testar com caso real** — invocar a skill em uma sessão onde o agente criou/modificou algo e verificar se o workflow genérico funciona

4. **Avaliar se precisa de mais exemplos** — conforme novos cenários forem testados

---

## Status de publicação

> **PÚBLICO** (a partir de 2026-05-17). A skill foi publicada como repositório aberto em `github.com/xBelowZero/congruence` sob licença MIT. Antes era marcada como confidencial; essa decisão foi revertida para permitir adoção e contribuição da comunidade.

---

## Artefatos da sessão

| Artefato | Caminho |
|----------|---------|
| Plano de implementação | `~/.gemini/antigravity/brain/2db18b26.../implementation_plan.md` |
| Task tracker | `~/.gemini/antigravity/brain/2db18b26.../task.md` |
| Walkthrough v2 | `~/.gemini/antigravity/brain/2db18b26.../walkthrough.md` |
| Este handoff | `.claude/skills/congruence/HANDOFF.md` |
