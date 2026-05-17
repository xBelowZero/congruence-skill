# Check: Features e fluxos anunciados

Use quando a sessão criou/modificou copy ou docs que descrevem **comportamento** do sistema (fluxos de usuário, capabilities, automações).

## Claims típicas em features/flows

- "Onboarding em 3 passos"
- "Fluxo de checkout em 1 clique"
- "Convide membros do time por email"
- "Automação dispara quando lead converte"
- "Exporta relatório em PDF"
- "Recupera senha por email"
- "Cancele a assinatura quando quiser"

## Como verificar — por padrão

### Fluxos de N passos

| Claim | Verificação |
|-------|-------------|
| "Em N passos" | Conte rotas/screens reais. N na copy = N no fluxo? |
| "Em 1 clique" | Realmente é 1 ação ou requer 2+? |
| "Sem cadastro" | Existe gate de auth antes do funil principal? |

### Permissões / multi-tenancy

| Claim | Verificação |
|-------|-------------|
| "Convide membros" | Endpoint `/invite` + envio de email + acceptance flow |
| "3 níveis de acesso" | RBAC code lista exatamente 3 roles |
| "Owner pode revogar acesso" | UI + endpoint + revogação de token/session |
| "Dados isolados por time" | RLS/where clause em TODAS as queries críticas |

### Automações / triggers

| Claim | Verificação |
|-------|-------------|
| "Dispara quando X acontece" | Listener/webhook/cron + handler funcional |
| "Notificação em tempo real" | WebSocket/SSE/polling + UI atualiza |
| "Email automático após Y" | Worker/job + template + envio real (não só log) |

### Exports / downloads

| Claim | Verificação |
|-------|-------------|
| "Exporta PDF" | Lib (puppeteer/pdfkit) + endpoint + Content-Type correto |
| "Exporta CSV" | Geração real, não download de string mock |
| "Backup em 1 clique" | Botão → endpoint → dump real, não apenas "feature flag on" |

## Red flags específicos

- Copy descreve 3 passos mas fluxo real tem 5 (passos escondidos: confirmação de email, aceite de termos, completar perfil)
- "Em 1 clique" mas requer login antes
- "Convide membros" mas só ADMIN consegue convidar, copy não menciona
- "Cancele quando quiser" mas botão de cancelar não existe na UI (só no Stripe)
- "Automação dispara" mas só roda manualmente
- "Tempo real" mas refresh manual necessário
- "Exporta PDF" mas é só print da tela com `window.print()`

## Cross-check obrigatório

Para cada fluxo descrito:
1. Trace cada passo em código (rota → handler → service → side effect)
2. Conte os passos reais
3. Compare com a copy

Para cada capability:
1. Grep do verbo principal ("export", "invite", "cancel")
2. Confirme implementação ponta-a-ponta (não só botão/UI)

## Bug clássico

Feature funciona em ambiente de dev mas usa mock. Copy anuncia como pronta. Em produção, falha porque credenciais/permissions/envvar não foram configuradas.