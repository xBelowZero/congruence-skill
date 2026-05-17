# Check: Integrações (Stripe, webhooks, APIs externas, OAuth)

Use quando a sessão menciona integração com serviço externo ou quando docs/copy anunciam suporte a um serviço.

## Claims típicas em integrações

- "Aceita pagamentos via Stripe/PagarMe/Mercado Pago"
- "Login com Google/GitHub/Apple"
- "Envia notificações por WhatsApp/email"
- "Sincroniza com Google Calendar"
- "Webhook configurado para `/api/webhooks/X`"
- "Disparo de evento via Segment/PostHog/Amplitude"

## Como verificar

Para qualquer integração, exija TODOS os 4:

| Item | Como confirmar |
|------|----------------|
| 1. SDK instalado | `package.json` lista `stripe`/`@google-cloud/...`/etc. |
| 2. Cliente inicializado | Grep `new Stripe(...)`, `new GoogleAuth(...)`, etc. |
| 3. Env vars configuradas | `.env.example` lista `STRIPE_SECRET_KEY`, etc. |
| 4. Handler/webhook funcional | Rota existe + parsing do payload + side effect real |

Faltou 1? → `parcialmente congruente` (com explicação de qual peça falta).
Faltou 2+? → `incongruente`.

## Red flags específicos

- README anuncia "Stripe integrado" mas só há `// TODO: integrar Stripe`
- Webhook handler existe mas não valida signature → não conta como "integrado"
- SDK importado mas nenhum método é chamado de fato
- Env var documentada mas nunca lida no código
- Handler sempre retorna `mock` ou `success` sem chamar API real
- "Sincroniza com Google" mas só lê do calendar, não escreve
- "Envia por WhatsApp" mas usa template que nunca foi aprovado pelo Meta
- "Pagamento via PIX" mas só gera QR code estático, sem callback

## Webhooks especificamente

| Aspecto | Mínimo aceitável |
|---------|------------------|
| Endpoint registrado | rota existe e responde 200 a POST válido |
| Signature validation | usa `STRIPE_WEBHOOK_SECRET`/`hmac` |
| Idempotência | check de event_id duplicado |
| Tipos de evento | lista no código bate com o que está documentado |
| Side effects | DB update real, não só log |

## Cross-check obrigatório

```bash
# Para cada integração mencionada em docs/copy:
grep -ri "SERVICE_NAME" --include="*.{js,ts,py,go,env*}" .
grep -ri "SECRET_KEY" .env.example
```

Se a única menção é em README/copy → claim é alucinação.