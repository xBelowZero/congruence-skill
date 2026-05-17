# Exemplo: Congruence Review — API e Documentação

Cenário: Um agente implementou uma REST API de gerenciamento de produtos e escreveu a documentação de uso.

---

# Congruence Review

## Resultado geral

Status geral: aprovado com ressalvas

Resumo:
- Total de itens analisados: 4
- Congruentes: 2
- Parcialmente congruentes: 1
- Incongruentes: 1
- Problemas altos: 1
- Problemas médios: 1

## Itens analisados

### 1. Endpoint GET /api/products retorna lista paginada

Claim analisada:
A documentação diz que `GET /api/products` aceita `?page=1&limit=20` e retorna `{ data: [...], total: number, page: number }`.

Fonte(s) verificadas:
- `app/api/products/route.ts`
- `docs/api.md`

Evidência:
O endpoint existe, aceita query params `page` e `limit`, e retorna o shape documentado. Paginação implementada com `offset` e `count(*)`.

Status: congruente
Severidade: nenhuma

---

### 2. Endpoint POST /api/products cria produto

Claim analisada:
A documentação diz que o body requer `{ name, price, category_id }` e retorna `201 Created`.

Fonte(s) verificadas:
- `app/api/products/route.ts`
- `lib/validations/product.ts`

Evidência:
O schema Zod em `product.ts` exige 5 campos obrigatórios: `name`, `price`, `category_id`, `description` e `sku`. A documentação lista apenas 3. Campos `description` e `sku` são required e causarão erro 400 se omitidos.

Status: incongruente
Severidade: alta

Problema:
Desenvolvedor seguindo a documentação enviará body incompleto e receberá erro 400 sem entender por quê. 2 campos obrigatórios não documentados.

Correção recomendada:
Adicionar `description` e `sku` na documentação como campos obrigatórios, incluindo tipo e formato esperado.

Arquivos recomendados para ajuste:
- `docs/api.md`

---

### 3. Autenticação via Bearer token

Claim analisada:
A documentação diz que todas as rotas de produtos exigem header `Authorization: Bearer <token>`.

Fonte(s) verificadas:
- `middleware.ts`
- `app/api/products/route.ts`

Evidência:
O middleware verifica JWT em todas as rotas `/api/products/*`. GET e POST estão protegidos. Correto.

Status: congruente
Severidade: nenhuma

---

### 4. Endpoint DELETE /api/products/:id

Claim analisada:
A documentação diz que DELETE remove o produto permanentemente e retorna `204 No Content`.

Fonte(s) verificadas:
- `app/api/products/[id]/route.ts`
- `lib/db/schema.ts`

Evidência:
O handler faz `UPDATE products SET deleted_at = NOW()` — soft delete, não remoção permanente. O produto continua no banco. Retorna `200` com body `{ deleted: true }`, não `204`.

Status: parcialmente congruente
Severidade: média

Problema:
1. Documentação diz "remove permanentemente" mas é soft delete. 2. Status code é 200, não 204.

Correção recomendada:
Atualizar documentação: "Marca o produto como removido (soft delete). O produto não aparecerá em listagens mas permanece no banco. Retorna `200 OK` com `{ deleted: true }`."

Arquivos recomendados para ajuste:
- `docs/api.md`

---

## Decisão pré-deploy

APROVAR COM RESSALVAS

Justificativa:
O problema alto (campos obrigatórios não documentados) deve ser corrigido antes do deploy da documentação. O problema médio (soft delete vs. hard delete) é aceitável mas deve ser corrigido.

## Próximas ações

1. Documentar campos `description` e `sku` como obrigatórios no POST
2. Corrigir descrição do DELETE para soft delete e status 200
3. Considerar adicionar exemplos de request/response na documentação
