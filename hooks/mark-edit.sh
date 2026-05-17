#!/usr/bin/env bash
# congruence: PostToolUse hook
# Marca estado quando edit toca arquivos que podem conter claims user-facing.
# Lê o tool input do stdin (JSON do Claude Code) e decide se marca pending.

set -euo pipefail

# Lê input JSON do harness via stdin
INPUT=$(cat)

# Extrai file_path do tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Padrões que disparam alerta de congruence
# (paths que costumam conter claims sobre o projeto)
PATTERNS=(
  "README"
  "CHANGELOG"
  "/docs/"
  "/help/"
  "/help-center/"
  "/faq/"
  "/landing/"
  "/marketing/"
  ".env.example"
  "package.json"
  "/components/"
  "/pages/"
  "/views/"
  "/templates/"
  ".html"
  ".mdx"
  ".md"
)

for pattern in "${PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    STATE_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude/state"
    mkdir -p "$STATE_DIR"
    echo "$FILE_PATH" >> "$STATE_DIR/congruence-pending"
    exit 0
  fi
done

exit 0