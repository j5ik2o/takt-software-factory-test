#!/usr/bin/env bash
set -u

cd "$(dirname "$0")/.."

fail=0
check() {
  local name="$1"
  shift
  if "$@"; then
    echo "ok - $name"
  else
    echo "not ok - $name"
    fail=1
  fi
}

file_exists() { [ -f docs/mode-c-1.md ]; }

heading_is() { [ "$(head -n 1 docs/mode-c-1.md 2>/dev/null)" = "# Mode C 1" ]; }

body_contains() { grep -qF 'parallel task 1' docs/mode-c-1.md 2>/dev/null; }

body_line_is() { grep -qxF 'parallel task 1' docs/mode-c-1.md 2>/dev/null; }

check "SCN-MODEC-P1 docs/mode-c-1.md exists" file_exists
check "SCN-MODEC-P1 docs/mode-c-1.md has '# Mode C 1' heading as first line" heading_is
check "SCN-MODEC-P1 docs/mode-c-1.md contains 'parallel task 1'" body_contains
check "MC1-BODY 'parallel task 1' stands on its own line (not split across lines)" body_line_is

exit "$fail"
