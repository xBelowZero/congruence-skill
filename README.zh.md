# congruence-skill

> **为 AI 编码 agent 提供的语义一致性审计。** 验证 AI agent 所说、所写或所记录的内容是否真的与项目实际功能相符。不是技术代码审查 — 检查关于代码的声明是否为真。

[🇺🇸](README.md) · [🇧🇷](README.pt-BR.md) · [🇪🇸](README.es.md) · [🇫🇷](README.fr.md) · [🇩🇪](README.de.md) · 🇨🇳

---

## 这是什么

AI 编码 agent 会产生幻觉。它们生成看起来正确但描述不存在事物的代码，写出与实际代码不一致的 README，或者发明集成。此 skill 审计这类错误 — **语义不一致**。

**核心原则：** 没有项目本身的证据，任何关于项目的声明都不为真。

## 它能捕获什么

agent（或项目的文档、UI、文案与配置）所**声明**的与代码**实际所做**的之间的任何分歧 —— 跨任何领域、技术栈或语言。只要某项声明可以对照源代码验证，`congruence` 就会检查。

一些示例（非穷尽）：FAQ 描述 3 步流程，但实际是 5 步；README 记录价格 49 元，但 Stripe 收 79 元；Landing 宣布"Stripe 集成"，实际只是一个 `// TODO`；Setup 要求 Node 18，但项目需要 Node 20；"123 个活跃 leads" 包括已删除的 leads；CTA "免费获取" 链接到 497 元的 checkout；函数在 1 个文件中重命名，47 个调用点损坏；文档说功能存在，但只有 mock 返回 `success`。

所有这些**都能通过任何技术代码审查**，因为代码编译并运行。`congruence` 是针对这类 bug 的屏障。

## 支持的 AI 平台

| 平台 | 适配器 | 状态 |
|------|--------|------|
| **Claude Code**（CLI / IDE / web） | 根 `SKILL.md` | ✅ 主要 |
| **Cursor** | [`adapters/cursor/`](adapters/cursor/) | ✅ 支持 |
| **GitHub Copilot CLI** | [`adapters/github-copilot/`](adapters/github-copilot/) | ✅ 支持 |
| **Gemini CLI / Antigravity** | [`adapters/gemini/`](adapters/gemini/) | ✅ 支持 |
| **OpenAI Codex CLI** | [`adapters/openai-codex/`](adapters/openai-codex/) | ✅ 支持 |
| **Aider** | [`adapters/aider/`](adapters/aider/) | ✅ 支持 |
| **Qwen Code CLI**（千问） | [`adapters/qwen/`](adapters/qwen/) | ✅ 支持 |
| **Kimi K2**（月之暗面） | [`adapters/kimi/`](adapters/kimi/) | ✅ 支持 |
| **Windsurf**（Codeium） | [`adapters/windsurf/`](adapters/windsurf/) | ✅ 支持 |
| **Cline**（VS Code） | [`adapters/cline/`](adapters/cline/) | ✅ 支持 |
| **Continue.dev** | [`adapters/continue/`](adapters/continue/) | ✅ 支持 |
| **Zed Editor** | [`adapters/zed/`](adapters/zed/) | ✅ 支持 |
| **JetBrains Junie** | [`adapters/jetbrains-junie/`](adapters/jetbrains-junie/) | ✅ 支持 |
| **Sourcegraph Cody** | [`adapters/cody/`](adapters/cody/) | ✅ 支持 |
| **ChatGPT Custom GPT** | [`adapters/chatgpt-custom-gpt/`](adapters/chatgpt-custom-gpt/) | ✅ 支持 |
| **通用 LLM**（任何 chat UI） | [`adapters/generic-prompt/`](adapters/generic-prompt/) | ✅ 支持 |

每个适配器有自己的 `INSTALL.md`，包含平台特定步骤。

## 快速安装（Claude Code）

```bash
# 项目本地（推荐）
cd your-project/
mkdir -p .claude/skills
git clone https://github.com/xBelowZero/congruence-skill.git .claude/skills/congruence

# 或全局（所有项目）
mkdir -p ~/.claude/skills
git clone https://github.com/xBelowZero/congruence-skill.git ~/.claude/skills/congruence
```

在会话中调用：`/congruence` 或"审计这次会话工作的一致性"。

其他平台请参见相关的 `adapters/<platform>/INSTALL.md`。

## 许可证

MIT — 见 [LICENSE](LICENSE)。

<!-- TRANSLATION NOTE: AI-generated. Native speaker review recommended. -->
