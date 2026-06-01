# dotfiles-claude

Personal [Claude Code](https://docs.anthropic.com/en/docs/claude-code) configuration.

## Quick Start

```bash
# Clone
git clone git@github.com:LostmanMing/dotfiles-claude.git ~/dotfiles-claude

# Symlink
ln -s ~/dotfiles-claude ~/.claude

# Setup API keys
bash ~/.claude/setup.sh deepseek

# Add to ~/.zshrc
source ~/.claude/integration.sh
source ~/.claude/integration-providers.sh
```

## Usage

```bash
claude             # Anthropic OAuth (requires /login)
claude-ds          # DeepSeek
claude-qwen        # Qwen
claude-anthropic   # Anthropic with API key
```

## Structure

```
├── .gitignore                   # Excludes settings.local.json, plugins, sessions
├── settings.json                # Theme, plugins, TUI (no keys)
├── integration.sh               # Claude wrapper
├── integration-providers.sh     # Provider shortcuts
├── setup.sh                     # Interactive key setup: bash setup.sh <provider>
├── providers/
│   ├── deepseek.json
│   ├── anthropic.json
│   └── qwen.json
└── README.md
```

## How it works

```
claude-ds
  → integration-providers.sh: claude-with deepseek
    → reads settings.local.json → deepseek key
    → reads providers/deepseek.json → model, base URL
    → ANTHROPIC_AUTH_TOKEN=<key> claude --settings providers/deepseek.json
```

## Security

- `settings.local.json` stores API keys, gitignored, `chmod 600`
- No secrets committed to git
