#!/usr/bin/env bash
# congruence: Stop hook
# Bloqueia o encerramento do turno se houver edits pendentes de auditoria.
# Lê JSON do harness via stdin (inclui stop_hook_active para evitar loop).

set -euo pipefail

INPUT=$(cat)

# Evita loop infinito: se já estamos num stop hook ativo, libera.
STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
if [[ "$STOP_ACTIVE" == "true" ]]; then
  exit 0
fi

# Resolve diretório do projeto. Em uso global sem CLAUDE_PROJECT_DIR,
# cai no cwd atual.
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$PWD}"
MARKER="$PROJECT_DIR/.claude/state/congruence-pending"

if [[ ! -f "$MARKER" ]]; then
  exit 0
fi

# Lista os arquivos pendentes (para contexto na mensagem).
PENDING=$(head -10 "$MARKER" | sed 's/^/  - /')

cat <<JSON
{
  "decision": "block",
  "reason": "Edits desta sessão tocaram texto/configs user-facing (README, docs, copy, package.json, components, etc.). Antes de encerrar, invoque /congruence para auditar se as claims batem com o código.\n\nArquivos marcados:\n${PENDING}\n\nApós rodar /congruence, delete o marcador: rm \"${MARKER}\""
}
JSON