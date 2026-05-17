# Checks por domínio

Progressive disclosure: cada check carrega apenas quando o escopo bate. Não leia todos — leia o relevante pro que mudou.

| Arquivo | Quando carregar |
|---------|----------------|
| [docs.md](docs.md) | Mudança tocou README, CHANGELOG, docs/, help-center, FAQ |
| [ui-copy.md](ui-copy.md) | Mudança tocou components, templates, strings user-facing |
| [integrations.md](integrations.md) | Sessão menciona Stripe/OAuth/webhook/serviço externo |
| [data-numbers.md](data-numbers.md) | Copy/UI exibem preços, datas, contagens, percentuais |
| [features-flows.md](features-flows.md) | Copy/docs descrevem comportamento de usuário ou fluxos |

## Roteamento por argumento

| `$ARGUMENTS` da invocação | Checks a carregar |
|---------------------------|-------------------|
| `/congruence` (sem arg) | Inferir do diff: carrega checks que casam com paths modificados |
| `/congruence docs` | `docs.md` |
| `/congruence copy` ou `/congruence ui` | `ui-copy.md` |
| `/congruence pricing` ou `/congruence numbers` | `data-numbers.md` |
| `/congruence stripe`, `/congruence webhook`, `/congruence oauth` | `integrations.md` |
| `/congruence flow` ou `/congruence feature` | `features-flows.md` |
| `/congruence all` | Todos (cuidado com tokens) |

## Inferência automática (sem argumento)

Olhe os paths modificados:

- `**/README*`, `**/CHANGELOG*`, `**/docs/**`, `**/help/**`, `**/faq/**` → docs
- `**/components/**`, `**/templates/**`, `**/views/**`, `**/pages/**`, `**/*.html` → ui-copy
- `**/webhooks/**`, `**/auth/**`, `**/payments/**`, `**/integrations/**` → integrations
- Mudanças em `prices.*`, `plans.*`, `config.*` com valores numéricos → data-numbers
- Qualquer fluxo novo (route + handler + UI) → features-flows