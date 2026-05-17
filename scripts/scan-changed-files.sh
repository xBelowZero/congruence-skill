#!/usr/bin/env bash
# scan-changed-files.sh
# Lista arquivos modificados, adicionados ou untracked relevantes para congruence review.
# Uso: bash scripts/scan-changed-files.sh [base_ref]
# Exemplo: bash scripts/scan-changed-files.sh origin/main

set -euo pipefail

BASE_REF="${1:-HEAD~1}"

echo "=== Congruence Scan ==="
echo "Base: $BASE_REF"
echo ""

# Extensões relevantes para congruência
EXTENSIONS="md|tsx|ts|jsx|js|html|json|yaml|yml|css|env|txt"

echo "--- Arquivos modificados (tracked) ---"
git diff --name-only "$BASE_REF" -- | grep -iE "\.($EXTENSIONS)$" || echo "(nenhum)"
echo ""

echo "--- Arquivos staged ---"
git diff --cached --name-only -- | grep -iE "\.($EXTENSIONS)$" || echo "(nenhum)"
echo ""

echo "--- Arquivos untracked ---"
git ls-files --others --exclude-standard | grep -iE "\.($EXTENSIONS)$" || echo "(nenhum)"
echo ""

echo "--- Resumo por tipo ---"
echo "Markdown (.md):"
git diff --name-only "$BASE_REF" -- | grep -iE "\.md$" | wc -l | xargs echo "  "
echo "Components (.tsx/.jsx):"
git diff --name-only "$BASE_REF" -- | grep -iE "\.(tsx|jsx)$" | wc -l | xargs echo "  "
echo "Logic (.ts/.js):"
git diff --name-only "$BASE_REF" -- | grep -iE "\.(ts|js)$" | grep -viE "\.(tsx|jsx)$" | wc -l | xargs echo "  "
echo "Config (.json/.yaml/.yml/.env):"
git diff --name-only "$BASE_REF" -- | grep -iE "\.(json|yaml|yml|env)$" | wc -l | xargs echo "  "
echo "HTML (.html):"
git diff --name-only "$BASE_REF" -- | grep -iE "\.html$" | wc -l | xargs echo "  "
echo ""
echo "=== Scan completo ==="
