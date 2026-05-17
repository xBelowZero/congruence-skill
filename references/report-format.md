# Formato do Relatório de Congruência

Template obrigatório para o relatório gerado pela skill.

---

```markdown
# Congruence Review

## Resultado geral

Status geral: [aprovado / aprovado com ressalvas / reprovado / revisão manual necessária]

Resumo:
- Total de itens analisados: X
- Congruentes: X
- Parcialmente congruentes: X
- Incongruentes: X
- Não verificáveis: X
- Problemas críticos: X
- Problemas altos: X

## Itens analisados

### 1. [Nome do item]

Tipo:
[FAQ / CTA / fluxo / rota / documentação / formulário / dashboard / outro]

Claim analisada:
[Afirmação extraída do texto sendo avaliado]

Fonte(s) verificadas:
- `arquivo/caminho.ext`
- `arquivo/caminho.ext`

Evidência:
[O que foi encontrado no código/dados que confirma ou contradiz a claim]

Status:
[congruente / incongruente / parcialmente congruente / não verificável / fora de escopo]

Severidade:
[crítica / alta / média / baixa / nenhuma]

Problema:
[Descrição do problema encontrado, se houver]

Correção recomendada:
[O que deve ser alterado para corrigir a incongruência]

Arquivos recomendados para ajuste:
- `arquivo/caminho.ext`

---

### 2. [Nome do item]

[Repetir estrutura acima para cada item]

---

## Decisão pré-deploy

[APROVAR / NÃO APROVAR / APROVAR COM RESSALVAS / EXIGIR REVISÃO MANUAL]

Justificativa:
[Por que essa decisão foi tomada]

## Próximas ações

1. [Ação específica com arquivo e descrição]
2. [Ação específica com arquivo e descrição]
3. [Ação específica com arquivo e descrição]
```

---

## Regras do relatório

1. **Sempre gerar**, mesmo que tudo esteja congruente
2. **Um item por seção** — não agrupar múltiplas claims
3. **Evidência concreta** — citar arquivo e trecho, não dizer "provavelmente"
4. **Correção acionável** — dizer exatamente o que mudar e onde
5. **Decisão explícita** — nunca terminar sem a seção "Decisão pré-deploy"
