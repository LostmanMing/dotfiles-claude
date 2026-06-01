# Source in ~/.zshrc (AFTER integration.sh):
#   source ~/.claude/integration-providers.sh
#
# Provider shortcuts: read API key from settings.local.json,
# merge with provider config, launch via claude() wrapper.

claude-with() {
    local provider="$1"
    shift

    local local_file="$HOME/.claude/settings.local.json"
    local provider_file="$HOME/.claude/providers/${provider}.json"

    if [ ! -f "$provider_file" ]; then
        echo "claude-with: unknown provider '${provider}'" >&2
        return 1
    fi

    if [ ! -f "$local_file" ]; then
        echo "API keys not configured. Run: bash ~/.claude/setup.sh ${provider}" >&2
        return 1
    fi

    local token
    token=$(jq -r ".${provider} // empty" "$local_file" 2>/dev/null)
    if [ -z "$token" ]; then
        echo "No key for '${provider}'. Run: bash ~/.claude/setup.sh ${provider}" >&2
        return 1
    fi

    ANTHROPIC_AUTH_TOKEN="$token" claude --settings "$provider_file" "$@"
}

claude-ds()        { claude-with deepseek "$@"; }
claude-qwen()      { claude-with qwen "$@"; }
claude-anthropic() { claude-with anthropic "$@"; }
