# dotfiles-claude

Personal [Claude Code](https://docs.anthropic.com/en/docs/claude-code) configuration.

Part of [LostmanMing/dotfiles](https://github.com/LostmanMing/dotfiles).

## Quick Start

```bash
# Clone
git clone git@github.com:LostmanMing/dotfiles-claude.git ~/.claude

# Setup API keys (one per provider)
bash ~/.claude/setup.sh deepseek
bash ~/.claude/setup.sh qwen

# Add to ~/.zshrc
source ~/.claude/integration.sh
source ~/.claude/integration-providers.sh
```

## Usage

```bash
# Default (Anthropic, via settings.json)
claude
opus
sonnet
haiku

# Provider shortcuts
deepseek              # DeepSeek
qwen                  # Qwen
anthropic             # Anthropic official

# Helpers
fuck                  # Fix last failed command
```

## How it works

```
deepseek
  → integration-providers.sh: claude-with deepseek
    → reads settings.local.json → deepseek key
    → reads providers/deepseek.json → model config
    → injects key + launches claude

claude
  → integration.sh: claude()
    → command claude --thinking-display summarized
    → uses default settings.json
```

## Structure

```
├── .gitignore                   # Excludes settings.local.json + local state
├── settings.json                # Theme, plugins, TUI (no keys)
├── integration.sh               # Claude wrapper + shortcuts (opus/sonnet/haiku/fuck)
├── integration-providers.sh     # Provider shortcuts (deepseek/qwen/anthropic)
├── setup.sh                     # Interactive key setup: bash setup.sh <provider>
├── providers/
│   ├── deepseek.json
│   ├── anthropic.json
│   └── qwen.json
└── README.md
```

## Security

- `settings.local.json` stores API keys, gitignored, `chmod 600`
- No secrets in any committed file
- Keys never touch environment variables (not visible in `ps`)
