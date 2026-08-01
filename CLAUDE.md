# Claude Config — LostmanMing

## 验证原则（所有 agent/LLM 通用）

**改了代码或配置，必须实际运行、观察真实输出来验证效果，禁止靠"读代码看起来对"来假设。没跑过就不许说"已生效/已修复/已完成"。只报告真实跑出来的结果，绝不伪造或推测工具输出。**

- 具体怎么验证按技术栈定（起服务、跑测试、执行命令看输出等），各项目的专用 skill 给出具体命令。
- Neovim 配置的验证见 `~/.config/nvim/skills/verify-nvim-config/`。
- 提交前 `git diff` 核对改动，提交后 `git status -sb` 确认同步状态，别凭空断言"已推送"。

## Plugins

| Plugin | 来源 |
|--------|------|
| clangd-lsp | claude-plugins-official |
| claude-hud | jarrodwatts/claude-hud |
