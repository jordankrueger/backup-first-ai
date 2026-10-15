#!/bin/bash
# Claude Code PreToolUse hook: refuse a short list of shell commands that are
# almost never what anyone meant to run. Setup is in the README.
#
# This matches the command TEXT, so a reworded command (/bin/rm, sh -c '...')
# can slip past it. It catches the common slip, not a determined attacker.
# The sandbox and your backup are the real protection.
#
# Exit 2 = blocked; the message below is shown to Claude.
# Needs jq (built into macOS 15 and later; `apt install jq` on Linux/WSL2).

COMMAND=$(jq -r '.tool_input.command // empty' 2>/dev/null)
[ -z "$COMMAND" ] && exit 0

block() {
  echo "BLOCKED by block-dangerous-commands.sh: $1. If you really mean it, ask the human to run it themselves." >&2
  exit 2
}

# A path ends at whitespace, end of line, or a shell separator.
END='([[:space:];&|)]|$)'

# Deleting the whole disk or home folder: rm -rf /, /*, ~, ~/, $HOME
if echo "$COMMAND" | grep -qE "\brm[[:space:]]+(-[-a-zA-Z]+[[:space:]]+)*(/|/\*|~/?|\\\$HOME/?|\\\$\{HOME\}/?)$END"; then
  block "rm on the root or home folder"
fi

# find ... -delete starting at root or home
if echo "$COMMAND" | grep -qE "\bfind[[:space:]]+(/|~/?|\\\$HOME/?)$END" && echo "$COMMAND" | grep -qE -- '-delete\b'; then
  block "find -delete over the root or home folder"
fi

# Force-push to main/master overwrites shared history
if echo "$COMMAND" | grep -qE '\bgit\b.*\bpush\b.*(-f\b|--force)' && echo "$COMMAND" | grep -qE '\b(main|master)\b'; then
  block "force-push to main/master"
fi

# Wiping a drive
if echo "$COMMAND" | grep -qE '\bmkfs(\.|[[:space:]])|\bdd\b.*\bof=/dev/|\bwipefs\b|\bdiskutil[[:space:]]+(eraseDisk|eraseVolume|zeroDisk|randomDisk|secureErase)\b'; then
  block "a command that erases a disk"
fi

# Destructive SQL: drop a table, empty a table, or DELETE with no WHERE
if echo "$COMMAND" | grep -qiE "drop[[:space:]]+(table|database|schema)\b|truncate[[:space:]]+(table[[:space:]]+)?[a-z_\"\`]|delete[[:space:]]+from[[:space:]]+[^[:space:];]+[[:space:]]*([;\"']|$)"; then
  block "SQL that drops or empties a table"
fi

exit 0
