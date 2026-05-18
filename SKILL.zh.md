---
name: congruence
description: 当您即将宣布工作完成、提交代码、打开 PR、更新 README/CHANGELOG/docs，或交付涉及用户可见文本的变更时使用此 skill — 审计 agent 所说、所写或所记录的内容是否真的与代码实际功能相符。在每次完成声明之前主动使用。触发时机：当 agent 使用"现已支持"、"已实现"、"可用"、"已完成"、"已修复"、"已添加"等措辞；当修改的文件包括 README、CHANGELOG、docs/、help-center、FAQ、landing 页、UI 文案或 AI prompts；在发布/部署之前。跳过：仅格式化变更、依赖版本升级、未涉及用户可见文本的内部重构，或仅测试文件的变更。
argument-hint: [scope?] [--dispatch-agent?]
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(scripts/scan-changed-files.sh:*), Task
---

# Congruence（一致性审计）

审计 agent 所说、所写或所记录的内容是否与代码实际功能相符。**这不是技术代码审查。** 这是**语义真实性**的审计。

**核心原则：** 没有项目本身的证据，任何关于项目的声明都不为真。

**违反此规则的字面就是违反它的精神。** Agent 刚刚生成的文本永远不是真理来源 — 即使加上"可能"、"应该是"、"我假设"等限定词也不是。

## 铁律（The Iron Law）

```
没有 GROUND-TRUTH 证据，就不能做用户可见的声明
```

如果您写了"应用现在能做 X"但无法指向证明 X 的文件/测试/路由，您**不能**发布该声明。降级为"计划中"、"部分完成"，或删除它。

## Gate Function — 在任何声明或文档编辑之前

按顺序执行。每一步未完成将阻止下一步。

1. **EXTRACT（提取）** — 列出输出中的每个具体声明（"支持 X"、"我修复了 Y"、"现在显示 Z"）。如需技巧请参见 [references/claim-extraction-guide.md](references/claim-extraction-guide.md)。
2. **MAP（映射）** — 对每个声明，指向证明它的文件:行/测试/路由。没有目标？标记为 `unverifiable（无法验证）`。
3. **AUDIT（审计）** — 对每个未证明的声明：**删除** 或 **降级**为"计划中/部分完成/进行中"。
4. **CROSS-CHECK（交叉检查）** — 确保 docs 中的术语与代码匹配（函数名、env vars、路由、标签）。
5. **EMIT（发出）** — 只有现在才生成消息/commit/PR/release notes。

## 按声明类型的证据表

| 声明 | 需要 | 不充分 |
|------|------|--------|
| "现已支持 X" | 通过的测试 + 可 grep 的函数/路由名 | "我加了一个 TODO"、"scaffolding 已存在" |
| "已修复 bug Y" | 失败测试 → 通过测试（red-green） | "代码改了，看起来对" |
| "README 说 X" | grep README + grep 代码，两者都包含 X | 仅编辑 README |
| "将 Y 重命名为 Z" | grep 整个 repo：0 次出现 Y | 仅在 1 个文件中重命名 |
| "移除了功能 W" | grep 代码 + README + 测试 → 0 次出现 | 仅从代码中移除 |
| "与 Stripe/X 集成" | 代码 + env var + handler/webhook 已配置 | mock 或 `// TODO: 集成 Stripe` |
| "价格/日期/数字 X" | grep 源码中的字面值（config、db seed 或硬编码） | 数字仅出现在生成的文案中 |
| "select 中有 X 个选项" | 组件恰好列出 X 项，不是 mock | "应该有大约 X 个选项" |

更深入的指南：[references/source-of-truth-priority.md](references/source-of-truth-priority.md)

## Red Flags — 停止

如果您发现自己在思考或写：

- "应该可以"、"可能是"、"我假设"、"它是隐含的"
- 在代码之前**先写** README（或之后，但没有重读代码）
- 不 grep 就粘贴 LLM 生成的 PR 描述
- "我会在 docs 中提到 X，用户自己找精确拼写"
- 不在整个 repo 中 grep 就重命名函数
- 状态报告包含"会话早期"实现的功能，没有重新验证
- `package.json`/`README` 描述的与 entry point 实际做的不同
- 营销/landing 文案承诺没有代码支持的好处

→ 停止。回到 Gate Function 的第 1 步。

## Excuse | Reality 表

| 借口 | 现实 |
|------|------|
| "用户稍后会修 README" | 发布的声明 = 已做的声明。验证或删除。 |
| "差不多" | 差不多 ≠ 真。代码是二元的，声明也是。 |
| "只是文档" | 文档**就是**下游 agent 的产品。 |
| "意图很清楚" | 意图 ≠ 实现。审计实现。 |
| "我在描述设计，不是当前状态" | 那就说"计划中"，不要用现在时。 |
| "变更的精神是对的" | 字面**就是**精神。审计实际的 diff。 |
| "就这一次" | 没有"就这一次"。每个声明都要审计。 |

## Workflow

### 1. 识别范围

```bash
bash scripts/scan-changed-files.sh
```

或直接 git diff。列出会话中创建/修改的文件。

如果 `$ARGUMENTS` 包含特定范围（如 `/congruence headlines`、`/congruence pricing`），仅过滤匹配范围的文件/区域。

### 2. 提取声明

读取每个会话输出和每个修改的文件。将隐式和显式陈述转换为客观声明。指南：[references/claim-extraction-guide.md](references/claim-extraction-guide.md)。

### 3. 寻找证据

对每个声明，在层级中寻找真理来源（可执行代码 > 路由/handler > schema > 测试 > config > UI > mock > docs > README > 注释 > agent 文本）。

### 4. 分类

| 状态 | 含义 |
|------|------|
| `congruent`（一致） | 证据确认 |
| `incongruent`（不一致） | 证据反驳 |
| `partially congruent`（部分一致） | 部分正确，有重要遗漏 |
| `unverifiable`（无法验证） | 证据不足 |

严重程度：[references/severity-rubric.md](references/severity-rubric.md)。

### 5. 报告

强制模板：[references/report-format.md](references/report-format.md)。

### 6. 部署前决策

- 任何 `critical（关键）` → **不批准**
- 未解决的 `high（高）` → **不批准**
- 重要区域有许多 `unverifiable` → **要求人工审查**
- 仅 `medium`/`low` → **附保留意见批准**
- 全部 `congruent` → **批准**

## 派遣审计子 agent（可选）

当范围较大（整页审计、长 release notes、多个区域），当前 agent 可能因生成了声明而存在偏见。**派遣一个全新的子 agent 可以避免自我确认。**

**何时询问用户：**
- 超过 5 个声明需要审计
- 变更涉及 3+ 个不同领域（如 docs + UI + 集成）
- Release notes 或 PR 描述超过 200 行
- 用户说"审计一切"而未指定范围

**如何询问：**

> "我检测到 N 个声明分布在 M 个区域。要我派遣一个专家子 agent 并行审计吗？（是/否/仅这部分）"

**如果用户接受**（或使用 `/congruence --dispatch-agent` 调用）：
- 使用 Task tool，模板见 [auditor-prompt.md](auditor-prompt.md)
- 传递范围、提取的声明列表、base/head SHAs
- 等待结构化报告并整合到最终决策

**如果 inline 运行**：继续使用上述 workflow。

> **隐藏成本**：每个子 agent 重新加载 CLAUDE.md + 所有 skill 描述。对于小型审计，派遣成本较高。默认为 inline。

## 何时不使用

- 技术代码审查（bug、性能、安全） → 使用 `requesting-code-review`
- 验证代码编译/测试通过 → 使用 `verification-before-completion`
- Linting、格式化
- 单独的单元测试审查

## 相关 skills

- **superpowers:verification-before-completion** — 验证**代码可工作**（测试、build）。`congruence` 验证**关于代码的声明**与代码匹配。在任何 release 之前同时使用两者。
- **superpowers:systematic-debugging** — 当 congruence 审计发现"代码做 X 但 docs 说 Y"时，系统地 debug 而不是仅 patch doc。
- **superpowers:requesting-code-review** — 技术质量。互补，而非替代。

## 为什么这很重要

Agent 会幻觉。技术代码审查无法捕获这一点，因为代码是正确的 — 错误的是**关于代码的信息**。

真实示例：
- FAQ 描述 3 步流程，实际上是 5 步
- README 记录价格 49 元，但 Stripe 收 79 元
- Landing 宣布 WhatsApp 集成，但实际不存在
- Setup 要求 Node 18，但项目需要 Node 20
- "123 个活跃 leads" 包括已删除的 leads
- CTA "免费获取" 链接到 497 元的 checkout
- Headline 中文，表单英文（语言混杂）
- Hero 中日期"2026 年 5 月 17 日"，footer 中"17/05/2025"

所有这些**都能通过任何技术代码审查**，因为代码编译并运行。`congruence` 是针对这类错误的屏障。

## 不可违反的规则

1. Agent 刚生成的文本**永远不是**真理来源
2. 看起来合理**不是**证据 — 需要具体证据
3. 没有证据 → `unverifiable`，**永远不**是 `congruent`
4. `critical`/`high` 问题**阻止** deploy/merge
5. 报告**始终**生成，即使一切都 `congruent`
6. **违反字面就是违反精神** — 没有例外，没有"就这一次"

---

**语言：** [🇺🇸 English](SKILL.md) · [🇧🇷 Português](SKILL.pt-BR.md) · [🇪🇸 Español](SKILL.es.md) · [🇫🇷 Français](SKILL.fr.md) · [🇩🇪 Deutsch](SKILL.de.md) · 🇨🇳 中文

<!-- TRANSLATION NOTE: AI-generated. Native speaker review recommended for technical terms. -->
