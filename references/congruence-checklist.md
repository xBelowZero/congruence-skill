# Checklist de Congruência

Perguntas a fazer para cada claim extraída, organizadas por **natureza da afirmação** (não por tipo de item).

---

## Claims sobre fluxo ou sequência

- [ ] A sequência de passos descrita é a sequência real no código?
- [ ] Existem passos intermediários omitidos (verificação, redirecionamento, loading)?
- [ ] O destino final do fluxo é o descrito?
- [ ] Condições de erro ou edge cases estão representados?

## Claims sobre dados exibidos

- [ ] A fonte dos dados exibidos é a correta?
- [ ] Filtros, contagens ou agregações refletem a lógica real?
- [ ] Dados deletados/inativos estão corretamente excluídos ou incluídos?
- [ ] Formatação (moeda, data, unidade) corresponde ao formato real?

## Claims sobre funcionalidade existente

- [ ] A funcionalidade mencionada está implementada no código?
- [ ] A funcionalidade está acessível (rota existe, botão existe, permissão permite)?
- [ ] A funcionalidade se comporta como descrito?
- [ ] Limitações não mencionadas existem (limites, condições, requisitos)?

## Claims sobre valores e configurações

- [ ] Valores numéricos (preços, limites, prazos) correspondem à configuração real?
- [ ] Feature flags, planos ou tiers mencionados existem no sistema?
- [ ] Variáveis de ambiente necessárias estão documentadas?
- [ ] Versões de dependências mencionadas são as corretas?

## Claims sobre integrações

- [ ] A integração mencionada está implementada no código?
- [ ] Endpoints, callbacks e payloads correspondem à implementação?
- [ ] Credenciais e configurações necessárias existem?

## Claims sobre permissões e acesso

- [ ] Roles ou níveis de acesso mencionados existem no sistema?
- [ ] Restrições descritas são enforçadas no código?
- [ ] Ações disponíveis para cada role correspondem à implementação?

## Claims sobre nomenclatura e navegação

- [ ] Nomes usados correspondem aos nomes reais no sistema?
- [ ] Caminhos de navegação (breadcrumbs, menus, URLs) são corretos?
- [ ] Labels e botões descrevem a ação que realmente executam?
