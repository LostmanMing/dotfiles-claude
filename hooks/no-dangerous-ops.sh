#!/usr/bin/bash
set -euo pipefail

# Block dangerous shell operations before they execute
# Fires on: PreToolUse (Bash)

# Read the command from stdin (Claude Code passes tool input as JSON)
CMD=$(jq -r '.tool_input.command // ""' 2>/dev/null || true)
echo "$(date '+%H:%M:%S') no-dangerous-ops: checking" >> /tmp/claude-hooks.log

# Fast-path: skip if no dangerous tokens present
if ! echo "$CMD" | grep -qiP 'mkfs|parted|fdisk|gdisk|shred|srm|wipe|cryptsetup|shutdown|reboot|poweroff|halt|init\s|telinit|killall|crontab\s+-r|docker\s+\w+\s+prune|iptables\s+-F|iptables\s+-X|nft\s+flush|ufw\s+reset|chmod\s+-R|chown\s+-R'; then
  exit 0
fi

# ── Checks ──────────────────────────────────────────
WARN=""

# Disk formatting
if echo "$CMD" | grep -qiP 'mkfs\.|mkfs\s|parted\s|fdisk\s|gdisk\s'; then
  if ! echo "$CMD" | grep -q '\-\-dry-run'; then
    WARN+="⚠️  Disk formatting/partitioning detected\n"
  fi
fi

# cryptsetup dangerous ops
if echo "$CMD" | grep -qiP 'cryptsetup\s+\w+\s+(luksFormat|erase|reencrypt)'; then
  if ! echo "$CMD" | grep -q '\-\-dry-run'; then
    WARN+="⚠️  cryptsetup destructive operation detected\n"
  fi
fi

# Write to /dev devices
if echo "$CMD" | grep -qiP '(>|>>|tee\s|cp\s|mv\s|dd\s.*of=).*/dev/(?!null|zero|random|urandom|tty|stdout|stderr|stdin|fd|log|console|ptmx|pts)'; then
  WARN+="⚠️  Writing to /dev device detected\n"
fi

# Write to protected system dirs
if echo "$CMD" | grep -qiP '(>|>>|tee\s|cp\s|mv\s|install\s).*/(etc|proc|sys|boot)/'; then
  WARN+="⚠️  Writing to /etc /proc /sys /boot detected\n"
fi

# Secure delete
if echo "$CMD" | grep -qiP 'shred|srm|wipe\s'; then
  WARN+="⚠️  Secure-delete command detected\n"
fi

# Power state
if echo "$CMD" | grep -qiP 'shutdown|reboot|poweroff|halt|init\s+[016]|telinit\s+[016]|systemctl\s+(poweroff|reboot|halt)'; then
  WARN+="⚠️  System power state change detected\n"
fi

# Recursive permission change
if echo "$CMD" | grep -qiP 'chmod\s+-R\s+777|chown\s+-R\s'; then
  WARN+="⚠️  Recursive chmod 777 / chown -R detected\n"
fi

# Docker prune
if echo "$CMD" | grep -qiP 'docker\s+(system|volume|image|container|network)\s+prune'; then
  WARN+="⚠️  Docker prune detected (irreversible data loss)\n"
fi

# Firewall wipe
if echo "$CMD" | grep -qiP 'iptables\s+(-F|--flush|-X)|nft\s+flush\s+ruleset|ufw\s+reset'; then
  WARN+="⚠️  Firewall rules wipe detected\n"
fi

# crontab -r
if echo "$CMD" | grep -qiP 'crontab\s+-r'; then
  WARN+="⚠️  crontab -r detected (deletes all cron jobs)\n"
fi

# killall
if echo "$CMD" | grep -qiP 'killall\s'; then
  WARN+="⚠️  killall detected (kills processes by name globally)\n"
fi

if [ -n "$WARN" ]; then
  echo "❌ DANGEROUS COMMAND BLOCKED:"
  echo "$WARN"
  echo "Command: $CMD"
  echo ""
  echo "If this is intentional, re-run with a # SAFE: <reason> comment in the command."
  exit 1
fi

exit 0
