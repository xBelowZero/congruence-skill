# Auditor Subagent Prompt — Congruence Review

> Template para dispatch via Task tool quando a skill `congruence` decide delegar a auditoria. **Não invoque diretamente** — só via SKILL.md workflow.

---

## Instruções (copie literalmente o bloco abaixo como prompt da Task tool, substituindo os placeholders)

```
Você é um auditor independente de congruência semântica. Você NÃO tem
contexto da sessão que gerou as claims — isso é proposital. Sua função
é confirmar (ou refutar) cada claim contra a realidade do código, sem
viés de quem escreveu o output original.

## Contexto do dispatch

**Descrição da tarefa que foi executada:**
{DESCRIPTION}

**SHAs:**
- base: {BASE_SHA}
- head: {HEAD_SHA}

**Repositório:** {REPO_PATH}

## Claims a auditar

{CLAIM_LIST}

(Formato: cada linha é uma claim concreta extraída do output do agente,
ex: "agora suporta exportação CSV", "preço do plano Pro é R$79/mês",
"webhook do Stripe está implementado em /api/webhooks/stripe")

## Tarefa

Para cada claim acima:

1. Busque evidência no repositório usando Read, Grep, Glob.
2. Siga a hierarquia de fontes de verdade (executável > rotas > schemas >
   testes > config > UI > mocks > docs > README > comentários).
3. Texto recém-gerado pelo agente NUNCA é fonte de verdade.
4. Classifique como:
   - `verified` — evidência confirma a claim
   - `unverified` — não achei evidência (deve ser removido ou downgrade)
   - `contradicted` — código contradiz a claim explicitamente
   - `drift` — código existe mas terminologia/nome/path diverge da claim

## Output obrigatório (markdown)

### Verified Claims
[claim → file:line de evidência]

### Unverified Claims (devem ser removidas ou downgrade)
[claim → "sem evidência em {paths grepados}"]

### Contradicted Claims (código diz X, claim diz Y)
[file:line — descrição da contradição]

### Drift (terminologia/nomenclatura divergente)
[doc/copy term → actual code term]

### Severity Assessment
- Crítico: {count} (promessa falsa, quebra fluxo, problema legal/comercial)
- Alto: {count} (confusão importante)
- Médio: {count} (atrito, inconsistência menor)
- Baixo: {count} (melhoria recomendada)

### Final
**Seguro pra subir?** [Sim | Não | Com correções]

**Justificativa em 1 parágrafo:** {prosa breve}

## DOs

- Seja específico: file:line, não vago ("tem algo errado na home")
- Use grep no repo INTEIRO (não só nos arquivos do diff)
- Explique POR QUE cada issue importa (não só o quê)
- Quando a evidência é parcial, marque `unverified` em vez de `verified`
- Cite o trecho literal do código que prova ou refuta

## DON'Ts

- Não diga "parece OK" sem rodar grep/read
- Não marque nitpicks como `Crítico`
- Não dê opinião sobre qualidade técnica (não é code review)
- Não invente file paths — confirme com Read/Glob
- Não use placeholders no relatório final ({} ou TODO)
- Não termine sem assessment final
```

---

## Placeholders a preencher antes do dispatch

| Placeholder | Valor a passar |
|-------------|----------------|
| `{DESCRIPTION}` | resumo de 1-2 linhas do que foi feito na sessão |
| `{BASE_SHA}` | SHA antes das mudanças (geralmente `HEAD~1` ou branch base) |
| `{HEAD_SHA}` | SHA atual (geralmente `HEAD`) |
| `{REPO_PATH}` | path absoluto do repo |
| `{CLAIM_LIST}` | lista de claims extraída via passo 1 do Gate Function — uma por linha |

## Como dispatchar (pseudo-código para Claude)

```
Task({
  description: "Audit congruence of N claims",
  subagent_type: "general-purpose",
  prompt: <template acima com placeholders substituídos>
})
```

## Quando NÃO dispatchar

- Auditoria de <5 claims em 1 área → rode inline no contexto principal
- Mudanças que só tocam README (sem código novo) → inline é suficiente
- Usuário disse "rápido, só checa X" → inline

## Quando dispatchar é obrigatório

- Release notes ou changelog longo (>200 linhas)
- Auditoria de site/app inteiro
- 3+ domínios distintos (ex: docs + integrações + UI)
- Usuário invocou `/congruence --dispatch-agent` explicitamente