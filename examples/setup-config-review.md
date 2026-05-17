# Exemplo: Congruence Review — Setup e Configuração

Cenário: Um agente configurou o projeto para deploy com variáveis de ambiente, scripts e instruções de setup.

---

# Congruence Review

## Resultado geral

Status geral: reprovado

Resumo:
- Total de itens analisados: 3
- Congruentes: 1
- Incongruentes: 2
- Problemas críticos: 1
- Problemas altos: 1

## Itens analisados

### 1. Script `npm run dev` inicia o servidor

Claim analisada:
O comando `npm run dev` inicia o servidor de desenvolvimento na porta 3000.

Fonte(s) verificadas:
- `package.json` (scripts)
- `next.config.ts`

Evidência:
`package.json` define `"dev": "next dev"`. Next.js usa porta 3000 por padrão. `next.config.ts` não altera a porta. Correto.

Status: congruente
Severidade: nenhuma

---

### 2. `.env.example` lista todas as variáveis necessárias

Claim analisada:
O arquivo `.env.example` documenta todas as variáveis de ambiente necessárias para o projeto funcionar.

Fonte(s) verificadas:
- `.env.example`
- `lib/env.ts`
- Grep por `process.env` no projeto

Evidência:
`.env.example` lista 6 variáveis. O grep por `process.env` encontra 11 variáveis usadas no código. As 5 faltantes são: `STRIPE_WEBHOOK_SECRET`, `RESEND_API_KEY`, `CRON_SECRET`, `NEXT_PUBLIC_POSTHOG_KEY`, `SENTRY_DSN`. Sem elas, partes do sistema falham silenciosamente.

Status: incongruente
Severidade: alta

Problema:
5 variáveis de ambiente usadas no código não estão documentadas. Desenvolvedor que seguir o `.env.example` terá falhas em webhooks, emails, cron jobs, analytics e monitoramento.

Correção recomendada:
Adicionar todas as 11 variáveis ao `.env.example` com comentários explicando cada uma.

Arquivos recomendados para ajuste:
- `.env.example`

---

### 3. README diz "Requer Node.js 18+"

Claim analisada:
O projeto funciona com Node.js versão 18 ou superior.

Fonte(s) verificadas:
- `README.md`
- `package.json` (engines)
- `.nvmrc`
- `.node-version`

Evidência:
`package.json` define `"engines": { "node": ">=20" }`. `.nvmrc` contém `20`. O projeto usa features de Node 20 (import assertions). Não funciona com Node 18.

Status: incongruente
Severidade: crítica

Problema:
Desenvolvedor instalando Node 18 (seguindo o README) terá erros de sintaxe. `package.json` enforce Node 20+ mas o README diz 18+.

Correção recomendada:
Atualizar README para "Requer Node.js 20 ou superior".

Arquivos recomendados para ajuste:
- `README.md`

---

## Decisão pré-deploy

NÃO APROVAR

Justificativa:
1 problema crítico (versão incorreta do Node pode impedir setup) e 1 problema alto (variáveis de ambiente faltantes causam falhas silenciosas).

## Próximas ações

1. Corrigir versão do Node no README (18 → 20)
2. Adicionar 5 variáveis faltantes ao `.env.example`
3. Re-executar congruence review
