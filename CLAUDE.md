# Claude Config — LostmanMing

## Hooks

配置文件: `settings.json`

| Hook | 触发时机 | 作用 |
|------|---------|------|
| `inject-time.sh` | UserPromptSubmit | 注入当前时间 |
| `inject-git-status.sh` | UserPromptSubmit | 注入当前仓库 git status |
| `no-dangerous-ops.sh` | PreToolUse (Bash) | 阻止危险命令 |

### 查看 hook 触发日志
```bash
tail -f /tmp/claude-hooks.log
```

### 手动测试 hook
```bash
bash ~/.claude/hooks/inject-time.sh
bash ~/.claude/hooks/inject-git-status.sh
```
