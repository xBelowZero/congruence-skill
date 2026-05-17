# Hierarquia de Fontes de Verdade

Ao verificar uma claim, buscar evidência seguindo esta ordem de prioridade. Fontes superiores têm **precedência absoluta** sobre fontes inferiores.

## Níveis de confiabilidade

### Nível 1 — Código executável real (máxima confiança)

O que o sistema **realmente faz** quando executa. Inclui:
- Código de produção (components, pages, handlers, services)
- Lógica de negócio implementada
- Funções e métodos que processam dados

**Por que é o mais confiável:** O código executável é o comportamento real do sistema. Não importa o que a documentação diz — o que o código faz é o que o usuário experimenta.

### Nível 2 — Rotas, controllers, handlers, actions, services e APIs

Definições de endpoints, middlewares, server actions e serviços:
- Arquivos de rotas (Next.js `app/api/`, Express routes, etc.)
- Controllers e handlers
- Server actions e API routes
- Middleware de autenticação e autorização

**Por que é confiável:** Define os pontos de entrada reais do sistema e o que está acessível.

### Nível 3 — Schemas, migrations, seeders, models e tipos

Definições de estrutura de dados:
- Schemas de banco (Prisma, Drizzle, SQL migrations)
- TypeScript types e interfaces
- Zod/Yup schemas de validação
- Models e entities
- Seeders e fixtures

**Por que é confiável:** Define a estrutura real dos dados que o sistema manipula.

### Nível 4 — Testes existentes

Testes que passam e documentam comportamento esperado:
- Testes unitários
- Testes de integração
- Testes e2e
- Snapshots

**Por que é confiável:** Testes que passam são afirmações verificadas sobre o comportamento do sistema. Mas cuidado: testes podem estar desatualizados ou incompletos.

### Nível 5 — Configurações reais

Arquivos de configuração do projeto:
- `.env`, `.env.local`, `.env.production`
- `next.config.js`, `vite.config.ts`
- `package.json` (scripts, dependências)
- Configurações de CI/CD
- Configurações de provedores (Supabase, Stripe, etc.)

**Por que é confiável:** Configurações determinam o comportamento real do ambiente.

### Nível 6 — Componentes de interface

Componentes UI que o usuário vê e interage:
- React/Vue/Svelte components
- Layouts e pages
- Formulários e modais
- Menus e navegação

**Por que é confiável:** São o que o usuário realmente vê, mas podem conter dados mockados ou condicionais.

### Nível 7 — Dados mockados usados em produção ou desenvolvimento

Dados de exemplo que alimentam a interface:
- Fixtures de desenvolvimento
- Seed data
- Mock data usado em componentes

**Atenção:** Só confiável se claramente usado no contexto sendo analisado. Dados mock podem não refletir o comportamento real.

### Nível 8 — Documentação interna recente

Documentação técnica do projeto:
- READMEs de módulos internos
- Comentários de arquitetura (ADRs)
- Docs em `/docs`
- CHANGELOG

**Atenção:** Pode estar desatualizada. Sempre cruzar com código real.

### Nível 9 — README e arquivos de instrução do projeto

Documentação de nível raiz:
- README.md principal
- CONTRIBUTING.md
- Guias de setup

**Atenção:** Frequentemente desatualizado. Nunca usar como fonte única.

### Nível 10 — Comentários no código (apoio secundário)

Comentários inline, JSDoc, docstrings:
- Úteis como contexto adicional
- Nunca como prova isolada
- Podem estar desatualizados em relação ao código que comentam

### Nível 11 — Texto recém-gerado pelo agente (nunca fonte de verdade)

Qualquer output do agente na sessão atual:
- Documentação recém-criada
- FAQs recém-escritos
- READMEs recém-gerados
- Textos de interface recém-criados

> **REGRA ABSOLUTA:** Texto recém-criado pelo agente **nunca** pode ser usado para validar a si mesmo. Se o agente escreveu "o primeiro passo é login" e a única evidência disso é o próprio texto que o agente escreveu, o item é `não verificável`.

---

## Regras de uso

1. **Sempre começar pelo nível 1** e descer conforme necessário
2. **Uma fonte de nível superior contradiz uma inferior** — a superior prevalece
3. **Múltiplas fontes de níveis similares** que concordam aumentam a confiança
4. **Ausência de evidência nos níveis 1-6** para uma claim essencial → classificar como `não verificável`
5. **Nível 11 isolado** → sempre `não verificável`
