# Exemplo: Congruence Review — Onboarding e Permissões

Cenário: Um agente implementou sistema de onboarding com roles (admin, manager, viewer) e configurou permissões de acesso.

---

# Congruence Review

## Resultado geral

Status geral: aprovado com ressalvas

Resumo:
- Total de itens analisados: 3
- Congruentes: 1
- Parcialmente congruentes: 1
- Incongruentes: 1
- Problemas altos: 1
- Problemas médios: 1

## Itens analisados

### 1. Onboarding redireciona para dashboard após último passo

Claim analisada:
Após completar o passo 3 (convidar equipe), o usuário é redirecionado para `/dashboard`.

Fonte(s) verificadas:
- `app/onboarding/step-3/page.tsx`
- `middleware.ts`

Evidência:
`step-3/page.tsx` chama `router.push('/dashboard')` no `onSubmit` (linha 45). O middleware verifica se onboarding foi completado via flag `onboarding_completed` antes de permitir acesso ao dashboard. Fluxo correto.

Status: congruente
Severidade: nenhuma

---

### 2. Sidebar mostra menu diferente por role

Claim analisada:
O componente `Sidebar` exibe itens de menu de acordo com a role do usuário: admin vê tudo, manager vê relatórios e equipe, viewer vê apenas dashboard.

Fonte(s) verificadas:
- `components/Sidebar.tsx`
- `lib/auth/permissions.ts`
- `lib/db/schema.ts`

Evidência:
`Sidebar.tsx` filtra menu items por `user.role`. Porém `permissions.ts` define 4 roles (admin, manager, viewer, **billing**), não 3. A role `billing` tem acesso a faturamento e pagamentos mas não aparece no filtro do Sidebar — usuários com role `billing` veem o mesmo menu que `viewer`.

Status: parcialmente congruente
Severidade: média

Problema:
Role `billing` existe no sistema mas não está representada no Sidebar. Usuários com essa role não conseguem acessar funcionalidades de faturamento pelo menu.

Correção recomendada:
Adicionar menu items para role `billing` (Faturamento, Pagamentos) ou documentar que `billing` é role interna sem acesso à UI.

Arquivos recomendados para ajuste:
- `components/Sidebar.tsx`

---

### 3. Admin pode deletar qualquer usuário

Claim analisada:
A interface de gerenciamento de equipe permite que admin delete qualquer usuário da organização.

Fonte(s) verificadas:
- `app/admin/team/page.tsx`
- `app/api/admin/users/[id]/route.ts`
- `middleware.ts`

Evidência:
O botão "Remover" existe na interface para role admin. O endpoint `DELETE /api/admin/users/[id]` verifica role admin. Porém não há proteção contra auto-deleção — admin pode deletar a si mesmo, perdendo acesso ao sistema e potencialmente deixando a organização sem admin.

Status: incongruente
Severidade: alta

Problema:
Ausência de proteção contra auto-deleção e contra remoção do último admin da organização. Pode causar lock-out completo.

Correção recomendada:
Adicionar validações: 1) impedir que admin delete a si mesmo, 2) impedir deleção se é o último admin da organização.

Arquivos recomendados para ajuste:
- `app/api/admin/users/[id]/route.ts`

---

## Decisão pré-deploy

APROVAR COM RESSALVAS

Justificativa:
O problema alto (auto-deleção de admin) é potencialmente destrutivo e deve ser corrigido. O problema médio (role billing sem menu) pode ser aceito para primeiro deploy.

## Próximas ações

1. Adicionar proteção contra auto-deleção de admin
2. Adicionar check de "último admin" antes de permitir deleção
3. Decidir sobre menu items para role `billing`
