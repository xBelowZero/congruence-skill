# Rubrica de Severidade

Usar esta rubrica para classificar problemas de congruência identificados durante a auditoria.

---

## Crítica

**Impacto:** Pode causar promessa falsa, quebra de fluxo principal, erro grave para o usuário, cobrança incorreta, problema legal/comercial ou deploy inseguro.

**Ação:** Bloqueio obrigatório de deploy/merge até correção.

### Exemplos

| Contexto | Problema |
|----------|----------|
| Landing page | Anuncia "teste grátis de 30 dias" mas o sistema cobra desde o primeiro dia |
| FAQ | Diz "cancele a qualquer momento" mas não existe funcionalidade de cancelamento |
| CTA | "Comece agora sem cartão" mas o formulário exige cartão de crédito |
| Fluxo | Documentação diz "faça login" mas o primeiro passo é cadastro com verificação de email |
| Preços | Exibe plano de R$49/mês mas o Stripe cobra R$59/mês |
| Permissões | Dashboard anuncia "acesso admin" mas a role não tem permissão para a ação |
| Integração | Diz "integrado com WhatsApp" mas não existe integração implementada |
| Dados | Exibe "123 clientes ativos" mas a query conta clientes inativos também |

---

## Alta

**Impacto:** Pode causar confusão importante, uso incorreto de funcionalidade, documentação enganosa ou erro em fluxo essencial.

**Ação:** Bloqueio recomendado de deploy até correção.

### Exemplos

| Contexto | Problema |
|----------|----------|
| FAQ | Descreve um fluxo de 3 passos quando na verdade são 5 passos |
| Dashboard | Menu mostra "Relatórios" mas a rota retorna 404 |
| Documentação | Instrui usar `npm run dev` mas o script correto é `npm run start:dev` |
| Formulário | Label diz "Email corporativo" mas aceita qualquer email |
| CTA | "Agende sua consulta" leva a uma página de contato genérica |
| README | Lista 8 features mas 2 não estão implementadas |
| Onboarding | Tutorial menciona um botão que não existe na interface atual |

---

## Média

**Impacto:** Pode causar atrito, inconsistência de nomenclatura, navegação incorreta ou desalinhamento parcial.

**Ação:** Corrigir antes do deploy se possível, aceitável com ressalvas.

### Exemplos

| Contexto | Problema |
|----------|----------|
| Menu | Item chama "Configurações" mas a página se chama "Preferências" |
| FAQ | Resposta parcialmente correta mas omite uma etapa relevante |
| Texto UI | Botão diz "Salvar rascunho" mas salva como publicado |
| Documentação | Versão do Node mencionada é 18 mas o projeto usa 20 |
| Dashboard | Coluna "Data de criação" mostra data de atualização |
| Breadcrumb | Caminho mostra "Home > Produtos" mas a URL é `/dashboard/items` |

---

## Baixa

**Impacto:** Inconsistência menor, texto pouco preciso ou melhoria recomendada.

**Ação:** Corrigir quando conveniente. Não bloqueia deploy.

### Exemplos

| Contexto | Problema |
|----------|----------|
| Texto UI | "Clique aqui para mais informações" — link funciona mas texto é vago |
| FAQ | Ortografia do nome de uma feature ligeiramente diferente do código |
| README | Ordem das instruções de setup poderia ser mais clara |
| Tooltip | Texto de ajuda descreve funcionalidade corretamente mas usa terminologia diferente da interface |
| Footer | Copyright mostra 2024 mas estamos em 2026 |
