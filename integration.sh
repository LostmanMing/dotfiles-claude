# Source in ~/.zshrc:
#   source ~/.claude/integration.sh
#
# claude → default (Anthropic), reads settings.json

case ":$PATH:" in
    *":$HOME/.claude/bin:"*) ;;
    *) PATH="$HOME/.claude/bin:$PATH" ;;
esac

claude() {
    PYTHONUNBUFFERED=1 \
    command claude --thinking-display summarized "$@"
}
