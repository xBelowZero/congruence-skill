# Exemplo: Congruence Review — Sistema de Pagamento

Cenário: Um agente implementou a integração de pagamento Stripe com checkout, webhooks e dashboard de assinaturas.

---

# Congruence Review

## Resultado geral

Status geral: reprovado

Resumo:
- Total de itens analisados: 4
- Congruentes: 1
- Parcialmente congruentes: 1
- Incongruentes: 2
- Problemas críticos: 1
- Problemas altos: 1

## Itens analisados

### 1. Componente de checkout exibe 3 planos

Claim analisada:
O componente `PricingTable` exibe Starter (R$29), Pro (R$79) e Enterprise (R$199).

Fonte(s) verificadas:
- `components/PricingTable.tsx`
- `lib/stripe/plans.ts`
- Stripe price IDs configurados em `.env.local`

Evidência:
`PricingTable.tsx` renderiza 3 cards com preços hardcoded. Porém `plans.ts` define os price IDs do Stripe que apontam para: Starter (R$39), Pro (R$99) e Enterprise (R$249). Os valores no componente não correspondem aos valores reais no Stripe.

Status: incongruente
Severidade: crítica

Problema:
Cliente vê R$29 na tela mas é cobrado R$39 no checkout Stripe. Diferença de preço pode configurar problema legal.

Correção recomendada:
Usar os preços de `plans.ts` dinamicamente em vez de hardcoded, ou atualizar os valores hardcoded para os reais.

Arquivos recomendados para ajuste:
- `components/PricingTable.tsx`

---

### 2. Webhook handler processa `checkout.session.completed`

Claim analisada:
O endpoint `/api/webhooks/stripe` processa o evento `checkout.session.completed` e ativa a assinatura do usuário.

Fonte(s) verificadas:
- `app/api/webhooks/stripe/route.ts`
- `lib/stripe/webhook-handlers.ts`

Evidência:
O handler existe e processa `checkout.session.completed`. Verifica assinatura do webhook, busca o usuário por email, atualiza `subscription_status` para `active`. Lógica correta e funcional.

Status: congruente
Severidade: nenhuma

---

### 3. Dashboard mostra "Assinatura ativa até DD/MM/YYYY"

Claim analisada:
O dashboard exibe a data de término da assinatura do usuário.

Fonte(s) verificadas:
- `app/dashboard/billing/page.tsx`
- `app/api/user/subscription/route.ts`
- `lib/db/schema.ts`

Evidência:
O componente busca `current_period_end` da API e formata como data. Porém a API retorna o campo do banco `subscription_end_date`, que só é atualizado no momento do checkout inicial. Renovações automáticas do Stripe não atualizam esse campo — não há webhook para `invoice.paid` que atualize a data.

Status: parcialmente congruente
Severidade: alta

Problema:
Após a primeira renovação, a data exibida ficará desatualizada. O usuário verá uma data antiga como se a assinatura estivesse expirada, mesmo estando ativa.

Correção recomendada:
Adicionar handler para `invoice.paid` no webhook que atualize `subscription_end_date`, ou buscar `current_period_end` diretamente da API do Stripe.

Arquivos recomendados para ajuste:
- `app/api/webhooks/stripe/route.ts`
- `lib/stripe/webhook-handlers.ts`

---

### 4. Botão "Cancelar assinatura" no dashboard

Claim analisada:
O botão cancela a assinatura do usuário imediatamente.

Fonte(s) verificadas:
- `app/dashboard/billing/page.tsx`
- `app/api/user/subscription/cancel/route.ts`

Evidência:
O botão existe e chama a API de cancelamento. Porém o endpoint usa `stripe.subscriptions.update({ cancel_at_period_end: true })` — não cancela imediatamente, cancela ao final do período. O texto do botão diz "Cancelar agora" e a mensagem de confirmação diz "sua assinatura será cancelada imediatamente", mas o comportamento real é cancelamento no final do período.

Status: incongruente
Severidade: alta

Problema:
Texto diz "cancelar imediatamente" mas o comportamento é "cancelar ao final do período". Expectativa incorreta para o usuário.

Correção recomendada:
Atualizar texto para "Cancelar ao final do período atual" e mensagem de confirmação para "Sua assinatura permanecerá ativa até {data} e não será renovada."

Arquivos recomendados para ajuste:
- `app/dashboard/billing/page.tsx`

---

## Decisão pré-deploy

NÃO APROVAR

Justificativa:
1 problema crítico (preços incorretos) e 2 problemas altos (data desatualizada, texto de cancelamento enganoso).

## Próximas ações

1. Corrigir preços no `PricingTable` para usar valores reais do Stripe
2. Adicionar webhook handler para `invoice.paid`
3. Corrigir texto do botão de cancelamento para refletir comportamento real
4. Re-executar congruence review
