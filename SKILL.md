---
name: congruence
description: Use sempre que estiver prestes a declarar trabalho como concluído, fazer commit, abrir PR, atualizar README/CHANGELOG/docs, ou subir uma mudança que afete texto user-facing — audita se o que o agente disse, escreveu ou documentou realmente bate com o que o código faz. Use proativamente antes de QUALQUER claim de conclusão. TRIGGER quando o agente usar frases como "agora suporta", "implementado", "funciona", "está pronto", "corrigido", "adicionado"; quando arquivos modificados incluírem README, CHANGELOG, docs/, help-center, FAQ, landing page, copy de UI, ou prompt de IA; antes de release/deploy. SKIP quando a mudança for apenas formatação, bump de versão de dependência, refactor interno sem texto user-facing tocado, ou alterações exclusivas em arquivos de teste.
argument-hint: [escopo?] [--dispatch-agent?]
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(scripts/scan-changed-files.sh:*), Task
---

# Congruence

Audita se o que foi dito, escrito ou documentado pelo agente bate com o que o código realmente faz. **Não é code review técnico.** É auditoria de **verdade semântica**.

**Core principle:** Nenhuma afirmação sobre o projeto é verdadeira sem evidência no próprio projeto.

**Violar a letra desta regra é violar o espírito dela.** Texto recém-criado pelo agente nunca é fonte de verdade — nem com qualificadores como "provavelmente", "deve estar", "presumi que".

## The Iron Law

```
NENHUMA CLAIM USER-FACING SEM EVIDÊNCIA DE GROUND-TRUTH
```

Se você escreveu "agora o app faz X" e não pode apontar para o arquivo/teste/rota que prova X, você **não pode** publicar essa claim. Downgrade para "planejado", "parcial" ou remova.

## Gate Function — antes de qualquer claim ou doc edit

Execute em ordem. Cada passo bloqueia o próximo se incompleto.

1. **EXTRAIR** — liste cada claim concreta no output ("suporta X", "corrigi Y", "agora exibe Z"). Use [references/claim-extraction-guide.md](references/claim-extraction-guide.md) se precisar de técnicas.
2. **MAPEAR** — para cada claim, aponte arquivo:linha/teste/rota que prova. Sem alvo? Marque como `não verificável`.
3. **AUDITAR** — para cada claim sem prova: **delete** ou **downgrade** para "planejado/parcial/em progresso".
4. **CROSS-CHECK** — garanta que terminologia em docs bate com código (nome de função, env var, rota, label).
5. **EMITIR** — só agora gere a mensagem/commit/PR/release notes.

## Tabela de evidência por tipo de claim

| Claim | Requer | Não é suficiente |
|-------|--------|------------------|
| "Agora suporta X" | Teste passando + nome de função/rota grepável | "Adicionei TODO", "scaffolding existe" |
| "Corrigi bug Y" | Teste vermelho → verde (red-green) | "Mudei o código, parece certo" |
| "README diz X" | grep README + grep código, ambos contêm X | edit no README sozinho |
| "Renomeei Y para Z" | grep no repo inteiro: 0 ocorrências de Y | renomeado em 1 arquivo |
| "Removi feature W" | grep código + README + testes → 0 ocorrências | removido só do código |
| "Integra com Stripe/X" | Código + env var + handler/webhook configurado | mock ou comentário "TODO Stripe" |
| "Preço/data/número X" | grep do valor literal no source (config, db seed, ou hard-coded) | número apareceu só na copy gerada |
| "Tem X opções no select" | Componente lista exatamente X items, não mock | "deve ter umas X opções" |

Guia mais profundo: [references/source-of-truth-priority.md](references/source-of-truth-priority.md)

## Red Flags — STOP

Se você se pegar pensando ou escrevendo:

- "deve funcionar", "provavelmente está", "presumi que", "tá implícito"
- Escrevendo README **antes** do código (ou após, sem reler o código)
- Colando descrição de PR gerada por LLM sem grep
- "Vou mencionar X nos docs, o usuário descobre o nome exato"
- Mudando nome de função sem grep no repo inteiro
- Status report inclui feature implementada "antes na sessão" sem re-verificar
- `package.json`/`README` descrevem algo diferente do que o entry point realmente faz
- Copy de marketing/LP promete benefício que não tem código por trás

→ PARE. Volte ao passo 1 do Gate Function.

## Tabela Excuse | Reality

| Desculpa | Realidade |
|----------|-----------|
| "O usuário corrige o README depois" | Claim publicada = claim feita. Verifique ou remova. |
| "Tá perto o suficiente" | Perto ≠ verdade. Código é binário, claim também. |
| "São só docs" | Docs **são** o produto para agentes downstream. |
| "A intenção tá clara" | Intenção ≠ implementação. Audite a implementação. |
| "Tô descrevendo o design, não o estado atual" | Então diga "planejado", não use presente. |
| "Espírito da mudança tá certo" | Letra É o espírito. Audite o diff real. |
| "Só essa vez" | Não tem só-essa-vez. Toda claim audita. |

## Workflow

### 1. Identificar escopo

```bash
bash scripts/scan-changed-files.sh
```

Ou git diff direto. Liste arquivos criados/modificados na sessão.

Se `$ARGUMENTS` contém um escopo específico (ex: `/congruence headlines`, `/congruence pricing`), filtre apenas arquivos/áreas que casam com o escopo.

### 2. Extrair claims

Leia cada output da sessão e cada arquivo modificado. Transforme afirmações implícitas e explícitas em claims objetivas. Guia: [references/claim-extraction-guide.md](references/claim-extraction-guide.md).

### 3. Buscar evidência

Para cada claim, busque a fonte de verdade na hierarquia (executável > rotas/handlers > schemas > testes > config > UI > mocks > docs > README > comentários > texto do agente).

### 4. Classificar

| Status | Significado |
|--------|-------------|
| `congruente` | Evidência confirma |
| `incongruente` | Evidência contradiz |
| `parcialmente congruente` | Parte certa, omissões importantes |
| `não verificável` | Sem evidência suficiente |

Severidade: [references/severity-rubric.md](references/severity-rubric.md).

### 5. Relatório

Template obrigatório: [references/report-format.md](references/report-format.md).

### 6. Decisão pré-deploy

- Qualquer `crítico` → **não aprovar**
- `alto` não resolvido → **não aprovar**
- Muitos `não verificável` em áreas essenciais → **exigir revisão manual**
- Apenas `médio`/`baixo` → **aprovar com ressalvas**
- Tudo `congruente` → **aprovar**

## Dispatch de subagente auditor (opcional)

Se o escopo é grande (auditoria de página inteira, release notes longas, múltiplas áreas), o agente atual pode estar enviesado por ter gerado as claims. **Dispatchar um subagente fresco evita auto-confirmação.**

**Quando perguntar ao usuário se quer dispatch:**
- Mais de 5 claims a auditar
- Mudanças tocam 3+ domínios distintos (docs + UI + integrações, por exemplo)
- Release notes ou PR description com mais de 200 linhas
- Usuário disse "audite tudo" sem especificar escopo

**Como perguntar:**

> "Detectei N claims em M áreas. Quer que eu dispare um subagente especialista pra auditar em paralelo? (sim/não/só essa parte)"

**Se usuário aceitar** (ou se invocou `/congruence --dispatch-agent`):
- Use a Task tool com o template em [auditor-prompt.md](auditor-prompt.md)
- Passe escopo, lista de claims extraídas, e SHAs base/head
- Aguarde o report estruturado e consolide na decisão final

**Se rodar inline**: continue com o workflow acima.

> **Custo oculto**: cada subagente recarrega CLAUDE.md + descriptions de skills. Dispatch é caro para auditorias pequenas. Default é inline.

## Quando NÃO usar

- Code review técnico (bugs, performance, segurança) → use `requesting-code-review`
- Verificar que código compila/testa passa → use `verification-before-completion`
- Linting, formatação
- Revisão isolada de testes unitários

## Skills relacionadas

- **superpowers:verification-before-completion** — verifica que o **código funciona** (testes, build). `congruence` verifica que as **claims sobre o código** batem com o código. Use os dois antes de qualquer release.
- **superpowers:systematic-debugging** — quando uma auditoria de congruência revela "código faz X mas docs dizem Y", debuga sistematicamente em vez de só patchar a doc.
- **superpowers:requesting-code-review** — qualidade técnica. Complementar, não substituto.

## Por que isso importa

Agentes alucinam. Code review técnico não pega isso porque o código está correto — o que está errado é a **informação sobre o código**.

Exemplos reais:
- FAQ descreve fluxo de 3 passos quando na verdade são 5
- README documenta preço R$49 mas Stripe cobra R$79
- Landing anuncia integração com WhatsApp que não existe
- Setup pede Node 18 mas projeto exige Node 20
- "123 leads ativos" conta leads deletados
- CTA diz "Garanta sua vaga gratuita" e leva a checkout de R$497
- Headline em PT, form em ES (multi-idioma misturado)
- Data "17 de maio de 2026" no hero, "17/05/2025" no footer

Tudo isso **passa em code review técnico** porque o código compila e roda. `congruence` é a barreira contra esse tipo de erro.

## Regras invioláveis

1. Texto recém-criado pelo agente **nunca** é fonte de verdade
2. Plausibilidade **não é** prova — exige evidência concreta
3. Sem evidência → `não verificável`, **nunca** `congruente`
4. Issues `crítica`/`alta` **bloqueiam** deploy/merge
5. Relatório gerado **sempre**, mesmo se tudo `congruente`
6. **Violar a letra é violar o espírito** — sem exceções, nem "só essa vez"
