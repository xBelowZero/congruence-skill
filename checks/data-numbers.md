# Check: Dados duros (preços, datas, números, percentuais, contagens)

Use sempre que copy/docs/UI exibirem valores numéricos específicos.

## Claims típicas em dados duros

- "Plano Pro: R$49/mês"
- "14 dias de trial grátis"
- "Suporta até 1000 contatos"
- "Garantia de 30 dias"
- "Lançamento em 17 de maio de 2026"
- "97% dos clientes recomendam"
- "Mais de 5000 vendas"

## Como verificar — por categoria

### Preços

| Onde buscar | Prioridade |
|-------------|-----------|
| Stripe/PagarMe/MP product config | 1ª (fonte de verdade) |
| `prices.json`/seed do banco | 2ª |
| Schema de plans/products | 3ª |
| Constants no código | 4ª |
| Copy/README | ÚLTIMA (nunca fonte de verdade) |

Se preço aparece em N lugares, TODOS devem bater. Discrepância = `crítico` (problema legal/cobrança).

### Datas e prazos

| Item | Verificação |
|------|-------------|
| Data de lançamento | grep da data em config/featureflag |
| "X dias de trial" | grep do número em código de trial (`trialDays`, `trial_period_days`) |
| "Garantia de N dias" | termo de uso + lógica de refund |
| Datas relativas ("amanhã", "próxima semana") | atenção: pode estar errada se a copy não atualizou |

### Contagens / capacidades

| Claim | Verificação |
|-------|-------------|
| "Até 1000 X" | grep do limite (`maxItems`, `LIMIT 1000`) |
| "N clientes/usuários" | é mock ou query real? Se query: filtra deletados? |
| "X% de Y" | é cálculo dinâmico ou hard-coded? |

## Red flags específicos

- Mesmo preço aparece com valores diferentes em hero/checkout/comparativo
- "Última atualização: ..." com data antiga (sinal de drift)
- "Plano gratuito" mas checkout cobra R$1
- "Garantia de 30 dias" mas refund-handler só permite 7
- Contadores fake ("Mais de 1000 clientes" hardcoded)
- "97% recomendam" sem fonte/N amostral citado
- Data de evento passado ainda exibida como "futuro"

## Cross-check obrigatório

```bash
# Para cada número/preço/data mencionado:
grep -rn "VALOR_LITERAL" --include="*.{js,ts,py,json,yaml,sql}" .
# Confirme que TODAS as ocorrências batem.
```

**Atenção**: valores formatados (R$49,00 vs R$49 vs 49 vs 4900 centavos) podem aparecer de jeitos diferentes. Grep por cada formato.

## Bug clássico que essa check pega

Sistema cobra em centavos no Stripe (`4900`) mas copy exibe `R$49,99` (formatação errada). Auditoria pega porque grep do valor literal não bate.