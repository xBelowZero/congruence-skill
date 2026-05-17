---
name: congruence
description: Use when any implementation, documentation, or content was created or modified in the current session and needs verification against project reality before deploy, merge, or delivery — covers payment systems, APIs, forms, dashboards, onboarding flows, pricing, permissions, UI copy, integrations, documentation, README, or any user-facing or system-critical output
disable-model-invocation: true
---

# Congruence Review

Audita se o que foi criado, alterado ou documentado na sessão atual está congruente com a realidade existente no projeto.

> **Princípio central:** Nenhuma afirmação sobre o projeto é verdadeira sem evidência no próprio projeto. Se a única evidência é o texto que o agente acabou de escrever, o item é `não verificável`, nunca `congruente`.

## Diferença fundamental

A congruence review não é code review. Code review verifica qualidade técnica (bugs, performance, padrões). Congruence review verifica **verdade semântica** — se o que foi dito, escrito, documentado ou exibido corresponde ao que o projeto realmente faz.

Uma implementação pode estar **tecnicamente perfeita** e **semanticamente incongruente**. Um FAQ pode estar **bem escrito** mas **factualmente incorreto** em relação ao código.

## Quando usar

Use para **qualquer** output da sessão atual que faça afirmações sobre o projeto:

- Código que exibe dados, mensagens ou labels para o usuário
- Documentação, README, instruções de setup
- Textos de interface, mensagens de erro/sucesso, tooltips
- Fluxos implementados (cadastro, pagamento, onboarding)
- Configurações que afetam comportamento (billing, permissões, feature flags)
- Integrações e webhooks configurados
- Qualquer output que será lido por usuários finais ou desenvolvedores

**Não usar para:**
- Code review técnico (bugs, performance, segurança)
- Linting ou formatação
- Revisão de testes unitários isoladamente

## Workflow

### 1. Entender o que foi feito na sessão

Identificar todos os arquivos criados ou modificados na sessão atual. Entender o que o usuário pediu e o que foi entregue. Ler cada arquivo alterado.

Para escopo automático via git: `bash scripts/scan-changed-files.sh`

### 2. Extrair claims verificáveis

Ler os outputs da sessão e transformar cada afirmação — explícita ou implícita — em uma claim objetiva que possa ser verificada contra o projeto.

Guia detalhado: [references/claim-extraction-guide.md](references/claim-extraction-guide.md)

Uma claim é qualquer coisa que o output faz o leitor acreditar sobre o projeto. Exemplos:

- Código exibe "R$49/mês" → claim: existe um plano que custa R$49/mês
- Botão diz "Exportar CSV" → claim: a funcionalidade de exportação CSV existe
- README diz "Node 18+" → claim: o projeto funciona com Node 18
- Fluxo redireciona para `/dashboard` → claim: a rota /dashboard existe e está acessível
- Sistema integra com Stripe → claim: integração com Stripe está implementada e funcional

### 3. Buscar evidência nas fontes de verdade

Para cada claim, buscar no projeto os arquivos que confirmam ou contradizem. Seguir a hierarquia de prioridade:

Guia detalhado: [references/source-of-truth-priority.md](references/source-of-truth-priority.md)

Resumo da hierarquia (da mais confiável à menos confiável):
1. Código executável real
2. Rotas, APIs, handlers
3. Schemas, migrations, tipos
4. Testes existentes
5. Configurações (.env, next.config, package.json)
6. Componentes de interface
7. Dados mock
8. Documentação interna
9. README
10. Comentários no código
11. **Texto recém-gerado pelo agente (nunca é fonte de verdade)**

### 4. Comparar e classificar

Para cada claim, atribuir um status:

| Status | Significado |
|--------|-------------|
| `congruente` | Evidência no projeto confirma a afirmação |
| `incongruente` | Evidência no projeto contradiz a afirmação |
| `parcialmente congruente` | Parte está correta, mas há omissões ou simplificações |
| `não verificável` | Sem evidência suficiente para confirmar ou negar |

E uma severidade quando houver problema:

| Severidade | Impacto |
|------------|---------|
| `crítica` | Promessa falsa, quebra de fluxo, erro grave, problema legal/comercial |
| `alta` | Confusão importante, funcionalidade descrita incorretamente |
| `média` | Atrito, inconsistência de nomenclatura, desalinhamento parcial |
| `baixa` | Inconsistência menor, melhoria recomendada |

Guia detalhado de severidade: [references/severity-rubric.md](references/severity-rubric.md)

### 5. Gerar relatório

Seguir o template: [references/report-format.md](references/report-format.md)

Para cada item incluir: claim analisada, fontes verificadas, evidência encontrada, status, severidade, problema e correção recomendada.

### 6. Decisão pré-deploy

- Qualquer problema `crítico` → **não aprovar**
- Problemas `alto` não resolvidos → **não aprovar**
- Muitos itens `não verificável` em áreas essenciais → **exigir revisão manual**
- Apenas `médio` ou `baixo` → **aprovar com ressalvas**
- Tudo `congruente` → **aprovar**

## Porque isso importa

Sem congruence review, um agente pode:
- Criar um FAQ que descreve um fluxo de 3 passos quando na verdade são 5
- Documentar um preço de R$49 quando o Stripe cobra R$79
- Anunciar integração com WhatsApp que não existe no código
- Escrever README com Node 18 quando o projeto exige Node 20
- Exibir "123 leads ativos" contando leads deletados

Esses erros passam em qualquer code review técnico porque o código está correto — o problema é que a **informação** está errada.

## Regras invioláveis

1. Texto recém-criado pelo agente **nunca** é fonte de verdade
2. Plausibilidade **não é** prova — precisa de evidência concreta
3. Se não há evidência, o item é `não verificável`, **nunca** `congruente`
4. Issues críticas e altas **bloqueiam** deploy/merge
5. O relatório deve ser gerado **sempre**, mesmo que tudo esteja congruente
