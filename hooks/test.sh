#!/bin/bash
# Checks block-dangerous-commands.sh against hooks/test-cases.txt.
# Run: bash hooks/test.sh
DIR="$(cd "$(dirname "$0")" && pwd)"
command -v jq >/dev/null || { echo "FAIL: jq is not installed, so the hook can't read commands"; exit 1; }

fail=0
while IFS='|' read -r want cmd; do
  case "$want" in block|invalid) code=2 ;; allow) code=0 ;; *) continue ;; esac
  if [ "$want" = invalid ]; then
    input="$cmd"
  else
    input=$(jq -n --arg c "$cmd" '{tool_name:"Bash",tool_input:{command:$c}}')
  fi
  printf '%s\n' "$input" | bash "$DIR/block-dangerous-commands.sh" 2>/dev/null
  got=$?
  [ "$got" = "$code" ] || { echo "FAIL (should $want, exit $got): $cmd"; fail=1; }
done < "$DIR/test-cases.txt"

TEMP=$(mktemp -d) || exit 1
trap 'rm -rf "$TEMP"' EXIT
mkdir -p "$TEMP/empty-bin" "$TEMP/My Project/.claude/hooks"
input='{"tool_name":"Bash","tool_input":{"command":"echo hello"}}'
printf '%s\n' "$input" | PATH="$TEMP/empty-bin" /bin/bash "$DIR/block-dangerous-commands.sh" 2>"$TEMP/error"
if [ "$?" != 2 ] || ! grep -q 'jq is not installed' "$TEMP/error"; then
  echo "FAIL: missing jq should block commands and identify the dependency"; fail=1
fi
ln -s "$(command -v jq)" "$TEMP/empty-bin/jq"
printf '%s\n' "$input" | PATH="$TEMP/empty-bin" /bin/bash "$DIR/block-dangerous-commands.sh" 2>"$TEMP/error"
if [ "$?" != 2 ] || ! grep -q 'grep is not installed' "$TEMP/error"; then
  echo "FAIL: missing grep should block commands and identify the dependency"; fail=1
fi

# Exercise the README's registration, not a separately maintained command.
snippet=$(awk '/^   "hooks": \{/ {copy=1} /^   ```/ && copy {exit} copy {sub(/^   /, ""); print}' "$DIR/../README.md")
config=$(printf '{%s}\n' "$snippet" | jq -e .) || { echo "FAIL: README hook registration is not valid JSON"; exit 1; }
hook_command=$(printf '%s\n' "$config" | jq -er '.hooks.PreToolUse[0].hooks[0].command') || { echo "FAIL: could not extract hook command from README"; exit 1; }
printf '%s\n' "$config" | jq -e '.hooks.PreToolUse[0].hooks[0].onFailure == "block"' >/dev/null || {
  echo "FAIL: README registration should block if the hook cannot run"; fail=1;
}
cp "$DIR/block-dangerous-commands.sh" "$TEMP/My Project/.claude/hooks/"
input='{"tool_name":"Bash","tool_input":{"command":"rm -rf ~"}}'
printf '%s\n' "$input" | CLAUDE_PROJECT_DIR="$TEMP/My Project" /bin/sh -c "$hook_command" 2>/dev/null
[ "$?" = 2 ] || { echo "FAIL: README registration should block in a project path with spaces"; fail=1; }

[ $fail = 0 ] && echo "All checks passed." || exit 1
