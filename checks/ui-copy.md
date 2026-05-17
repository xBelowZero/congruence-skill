# Check: Copy de UI (labels, botões, mensagens, headlines)

Use quando a sessão tocou em components, templates, ou strings de UI/marketing.

## Claims típicas em copy

- Headline: "Garanta sua vaga gratuita"
- Botão: "Exportar CSV", "Baixar PDF", "Conectar Stripe"
- Empty state: "Você ainda não tem leads"
- Mensagem de erro: "Email inválido", "Sessão expirou"
- Tooltip: "Mostra apenas leads dos últimos 30 dias"
- CTA: "Comece grátis"

## Como verificar

| Claim na copy | Verificação |
|---------------|-------------|
| "Garanta sua vaga gratuita" | Form/checkout cobra? Se sim → incongruente |
| "Exportar CSV" | Existe handler que gera CSV? Grep por `Content-Type: text/csv` ou `papaparse`/`csv-stringify` |
| "Você tem N leads" | Query conta `WHERE deleted_at IS NULL`? Conta soft-deleted? |
| "Conectar Stripe" | OAuth flow existe? Webhook configurado? Ou é mock? |
| "Sessão expira em X min" | Configuração de session/jwt confirma X min? |
| "Suporte 24/7" | Existe canal de suporte? Página /support? Email? |
| "Frete grátis acima de R$X" | Lógica de frete confirma R$X exato? |

## Red flags específicos

- CTA e ação do form discordam ("Cadastre-se" → leva pra checkout)
- Empty state assume feature que não existe ainda
- Mensagem de erro descreve causa errada (diz "email" mas valida "telefone")
- Headline em PT, form em ES (multi-idioma misturado)
- Número específico ("123 clientes") que é mock/hardcoded
- Tooltip explica filtro que não é aplicado
- Preço no CTA difere do checkout
- "Cancelar a qualquer momento" mas o flow não tem botão de cancelar

## Cross-check obrigatório

Para cada **número, preço, prazo, ou condição** na copy:
1. Grep do valor literal no source
2. Confirme no schema/config/seed
3. Se só aparece na copy → incongruente

Para cada **botão/CTA**:
1. Encontre o `onClick`/`href`/`action`
2. Confirme que a ação descrita é a ação real
3. Atenção a redirects/middlewares que mudam o destino