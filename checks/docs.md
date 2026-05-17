# Check: Documentação (README, CHANGELOG, docs/)

Use quando a mudança da sessão tocou em arquivos de documentação ou quando o agente gerou conteúdo doc-like (release notes, PR description, etc.).

## Claims típicas em docs

- "Setup requer Node 18+"
- "Suporta X formatos de arquivo"
- "Compatível com Y framework"
- "Instalado via `npm install ...`"
- "Configuração em `config.yaml`"
- "Roda em PostgreSQL 15+"

## Como verificar

| Claim | Onde buscar evidência |
|-------|----------------------|
| Requisitos de Node/Python/Ruby | `package.json` `engines`, `.nvmrc`, `.python-version`, `Gemfile` |
| Comando de instalação | `package.json` scripts, `Makefile`, `bin/` |
| Banco de dados | docker-compose.yml, schema.prisma, migrations/, .env.example |
| Variáveis de ambiente | `.env.example`, código que lê `process.env`/`os.environ` |
| Versões de dependências | `package-lock.json`, `yarn.lock`, `requirements.txt`, `poetry.lock` |
| Path de configuração | grep do filename literal no código |
| Comandos CLI documentados | bin/, scripts da CLI, ou route handler |

## Red flags específicos

- README diz "v2.0" mas package.json tem "1.4.3"
- CHANGELOG menciona feature que não tem commit
- README pede env var que não é lida em nenhum lugar
- "Como contribuir" referencia arquivo que não existe (CONTRIBUTING.md)
- Comando documentado não bate com o que está em `package.json` scripts

## Cross-check obrigatório

Para CADA comando/path/env var mencionado em docs:
```bash
grep -r "NOME_LITERAL" --include="*.{js,ts,py,go,rb,sh,json,yaml,yml}"
```
Se 0 matches → claim é incongruente.