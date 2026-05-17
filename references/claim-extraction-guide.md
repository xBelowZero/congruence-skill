# Guia de Extração de Claims

Como transformar textos, FAQs, CTAs, fluxos e documentações em afirmações objetivas e verificáveis.

## O que é uma claim

Uma **claim** é uma afirmação declarativa que pode ser verificada contra o código e dados reais do projeto. Toda afirmação explícita ou implícita em um texto é uma claim potencial.

> Leia o texto como se fosse um usuário que nunca viu o sistema. O que esse texto faz você acreditar? Cada crença gerada é uma claim.

## Técnicas de extração

### 1. Claims explícitas

| Texto original | Claim extraída |
|----------------|----------------|
| "Faça login para começar." | O primeiro passo para usar o sistema é fazer login. |
| "Planos a partir de R$29/mês." | Existe um plano que custa R$29/mês. |
| "Integrado com Slack e Discord." | O sistema possui integração funcional com Slack. O sistema possui integração funcional com Discord. |
| "Cancele quando quiser." | Existe funcionalidade de cancelamento acessível ao usuário. |

### 2. Claims implícitas

| Texto original | Claim implícita |
|----------------|-----------------|
| "Comece agora — é grátis!" | O cadastro/uso inicial não requer pagamento. |
| CTA "Agendar reunião" | Existe funcionalidade de agendamento de reuniões. |
| Menu com item "Relatórios" | Existe uma página/funcionalidade de relatórios acessível. |
| Dashboard mostrando "52 leads" | A contagem de leads exibida reflete dados reais da base. |

### 3. Claims de fluxo

| Texto original | Claims de fluxo |
|----------------|-----------------|
| "1. Cadastre-se 2. Escolha plano 3. Comece" | O fluxo segue essa ordem. Não existem passos omitidos (verificação de email, onboarding, etc.). |
| "Faça login e acesse seu dashboard" | Após login, o usuário é redirecionado para o dashboard. |

### 4. Claims de dados

| Texto original | Claim de dados |
|----------------|----------------|
| "Mais de 1.000 clientes" | Existe fonte para essa afirmação na base de dados. |
| Tabela de preços com 3 planos | Existem exatamente 3 planos configurados no billing. |

### 5. Claims de capacidade

| Texto original | Claim de capacidade |
|----------------|---------------------|
| "Gere relatórios em PDF" | O sistema exporta relatórios em PDF. |
| "Aceita PIX e cartão" | Pagamento via PIX está implementado. Pagamento via cartão está implementado. |

## Regras de extração

1. **Uma frase pode conter múltiplas claims** — extrair todas
2. **Conjunções ("e", "ou") indicam claims separadas** — "Slack e Discord" = 2 claims
3. **Omissões são claims implícitas** — tutorial que pula etapa implica que ela não existe
4. **Negações são claims** — "Sem cartão" = "Não é necessário cartão"
5. **Valores numéricos são claims** — verificar contra fonte real
6. **Ordem é uma claim** — "1, 2, 3" implica ordem real

## Priorização

1. Claims de fluxo principal (cadastro, login, pagamento)
2. Claims financeiras (preços, planos, cobranças)
3. Claims de capacidade (features anunciadas)
4. Claims de dados (números exibidos)
5. Claims de interface (nomes, menus, navegação)
6. Claims secundárias (tooltips, footer)
