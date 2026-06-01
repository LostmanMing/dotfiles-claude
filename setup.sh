#!/bin/bash
# Store API key for a Claude Code provider.
# Usage: bash setup.sh <provider>
# Example: bash setup.sh deepseek

set -e

LOCAL_FILE="${HOME}/.claude/settings.local.json"
PROVIDERS_DIR="${HOME}/.claude/providers"

provider="$1"

if [ -z "$provider" ]; then
    echo "Usage: bash setup.sh <provider>"
    echo ""
    echo "Available providers:"
    for f in "$PROVIDERS_DIR"/*.json; do
        [ -f "$f" ] || continue
        echo "  $(basename "$f" .json)"
    done
    exit 1
fi

provider_file="${PROVIDERS_DIR}/${provider}.json"
if [ ! -f "$provider_file" ]; then
    echo "Error: unknown provider '${provider}'"
    echo "Available: $(ls -1 "$PROVIDERS_DIR"/*.json 2>/dev/null | xargs -n1 basename | sed 's/.json//' | tr '\n' ' ')"
    exit 1
fi

read -sp "Paste your ${provider} API key: " api_key
echo ""

if [ -z "$api_key" ]; then
    echo "Error: API key cannot be empty"
    exit 1
fi

# Read existing keys, update the one for this provider
if [ -f "$LOCAL_FILE" ]; then
    updated=$(jq --arg key "$api_key" ".${provider} = \$key" "$LOCAL_FILE" 2>/dev/null)
else
    updated="{}"
    updated=$(echo "$updated" | jq --arg key "$api_key" ".${provider} = \$key")
fi

echo "$updated" > "$LOCAL_FILE"
chmod 600 "$LOCAL_FILE"

echo ""
echo "✓ Key saved for ${provider}"
case "$provider" in
    deepseek) cmd="claude-ds" ;;
    qwen)     cmd="claude-qwen" ;;
    *)        cmd="claude-${provider}" ;;
esac
echo "  Run: ${cmd}"
