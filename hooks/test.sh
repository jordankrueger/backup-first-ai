#!/bin/bash
# Checks block-dangerous-commands.sh against hooks/test-cases.txt.
# Run: bash hooks/test.sh
DIR="$(dirname "$0")"
command -v jq >/dev/null || { echo "FAIL: jq is not installed, so the hook can't read commands"; exit 1; }

fail=0
while IFS='|' read -r want cmd; do
  case "$want" in block) code=2 ;; allow) code=0 ;; *) continue ;; esac
  jq -n --arg c "$cmd" '{tool_name:"Bash",tool_input:{command:$c}}' | bash "$DIR/block-dangerous-commands.sh" 2>/dev/null
  got=$?
  [ "$got" = "$code" ] || { echo "FAIL (should $want, exit $got): $cmd"; fail=1; }
done < "$DIR/test-cases.txt"

[ $fail = 0 ] && echo "All checks passed." || exit 1
