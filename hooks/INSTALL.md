# Hooks opcionais — auto-suggestion da congruence

Os hooks deste diretório são **opcionais**. A skill `congruence` funciona perfeitamente sem eles via invocação manual (`/congruence`).

Use os hooks quando quiser que o harness **lembre automaticamente** de rodar `/congruence` ao final de um turno onde houve edits relevantes (README, docs, copy, etc.).

## Como funciona

Dois hooks trabalham juntos:

1. **`PostToolUse`** (matcher `Edit|Write|MultiEdit`) — executa `mark-edit.sh`, que verifica se o arquivo editado bate em padrões relevantes (README, /docs, /help, /components, etc.) e cria um marcador em `.claude/state/congruence-pending`.

2. **`Stop`** (command) — executa `stop-check.sh`, que verifica o marcador. Se existir, retorna `{"decision": "block", "reason": "..."}` para o harness — bloqueia o encerramento do turno e força Claude a invocar a skill. Respeita `stop_hook_active` no input para evitar loops infinitos.

Depois de rodar `/congruence`, **a skill (ou você) deve deletar** o marcador para liberar o próximo Stop: `rm "${CLAUDE_PROJECT_DIR}/.claude/state/congruence-pending"`.

## Instalação

### Opção A — Project-local (recomendado)

Edite `.claude/settings.local.json` do projeto:

```bash
# Se o arquivo não existe:
cp .claude/skills/congruence/hooks/hooks.example.json .claude/settings.local.json
chmod +x .claude/skills/congruence/hooks/mark-edit.sh

# Se já existe, faça merge manual do bloco "hooks" do .example.json.
```

### Opção B — Global (todos os projetos)

Instale a skill em `~/.claude/skills/congruence/` (`git clone https://github.com/xBelowZero/congruence-skill.git ~/.claude/skills/congruence`), depois edite `~/.claude/settings.json` adicionando os hooks com path absoluto:

```jsonc
"PostToolUse": [
  {
    "matcher": "Edit|Write|MultiEdit",
    "hooks": [{ "type": "command", "command": "/Users/SEU_USER/.claude/skills/congruence/hooks/mark-edit.sh" }]
  }
],
"Stop": [
  {
    "hooks": [{ "type": "command", "command": "/Users/SEU_USER/.claude/skills/congruence/hooks/stop-check.sh" }]
  }
]
```

Os scripts usam `CLAUDE_PROJECT_DIR` (ou `$PWD` como fallback) para o marcador — funcionam em qualquer projeto.

### Opção C — Sem hooks

Não instale nada. Use manualmente: `/congruence` quando achar relevante.

## Verificação

Faça um Edit em `README.md` qualquer e termine o turno. Se Claude continuar sem encerrar e perguntar se quer rodar `/congruence`, está funcionando.

## Custos

- **PostToolUse**: ~5ms por edit (shell script puro, zero LLM).
- **Stop hook prompt-based**: 1 chamada Haiku por fim-de-turno. Custo desprezível (~$0.0001).

## Desinstalação

Remova o bloco `hooks` do `.claude/settings.local.json` (ou `~/.claude/settings.json`).

## Troubleshooting

### "Stop hook runs forever"

Significa que o `congruence-pending` não está sendo deletado. Verifique:
1. A skill foi invocada após o Stop? (`grep -c congruence` em logs)
2. O arquivo foi deletado? (`ls .claude/state/`)

Workaround manual: `rm .claude/state/congruence-pending` e retente.

### "PostToolUse não cria o marcador"

1. Confirme que `mark-edit.sh` tem `+x`: `ls -la .claude/skills/congruence/hooks/mark-edit.sh`
2. Confirme que `jq` está instalado: `which jq`
3. Confirme path: `echo $CLAUDE_PROJECT_DIR`

### "Quero customizar quais paths disparam"

Edite o array `PATTERNS=()` no início de `mark-edit.sh`. Adicione/remova padrões conforme seu projeto.

## Por que não bundle como SessionStart hook?

A skill `congruence` precisa de **contexto da sessão** (o que foi feito) para auditar. SessionStart hook roda antes de qualquer trabalho ter sido feito — seria inútil. Stop+PostToolUse é o mecanismo correto: reagir ao que acabou de acontecer.