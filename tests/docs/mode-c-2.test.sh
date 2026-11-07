#!/usr/bin/env bash
set -u

repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
target="$repo_root/docs/mode-c-2.md"

failures=0

fail() {
  printf 'FAIL %s: %s\n' "$1" "$2"
  failures=$((failures + 1))
}

pass() {
  printf 'PASS %s\n' "$1"
}

check_exists() {
  local name="DOC-EXISTS"
  if [ -f "$target" ]; then
    pass "$name"
  else
    fail "$name" "docs/mode-c-2.md does not exist"
  fi
}

check_heading() {
  local name="DOC-HEADING"
  if [ ! -f "$target" ]; then
    fail "$name" "cannot read heading: docs/mode-c-2.md is missing"
    return
  fi
  if grep -qxF '# Mode C 2' "$target"; then
    pass "$name"
  else
    fail "$name" "no line equals '# Mode C 2'"
  fi
}

check_body() {
  local name="DOC-BODY"
  if [ ! -f "$target" ]; then
    fail "$name" "cannot read body: docs/mode-c-2.md is missing"
    return
  fi
  if grep -qxF 'parallel task 2' "$target"; then
    pass "$name"
  else
    fail "$name" "no line equals 'parallel task 2'"
  fi
}

check_no_extra() {
  local name="NO-EXTRA"
  if [ ! -d "$repo_root/docs" ]; then
    pass "$name"
    return
  fi
  local unexpected
  unexpected="$(find "$repo_root/docs" -type f ! -path "$target" -print)"
  if [ -z "$unexpected" ]; then
    pass "$name"
  else
    fail "$name" "unexpected files under docs/: $unexpected"
  fi
}

check_exists
check_heading
check_body
check_no_extra

if [ "$failures" -ne 0 ]; then
  printf '%d check(s) failed\n' "$failures"
  exit 1
fi

printf 'all checks passed\n'
