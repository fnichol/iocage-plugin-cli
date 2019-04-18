#!/usr/bin/env sh

# shellcheck source=test_helpers.sh
. "${0%/*}/test_helpers.sh"

testAborts() {
  run "$bin" template render

  assertNotEquals "$status" 0
  assertStderrContains '^USAGE:$'
  assertStderrContains '^xxx missing argument$'
}

testHelpSubcmd() {
  run "$bin" template render help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template-render)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagLong() {
  run "$bin" template render --help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template-render)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagShort() {
  run "$bin" template render -h

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template-render)'"
  assertStdoutContains '^USAGE:$'
}

testNoTemplatingWithNonexistantCfgPath() {
  # Ensure no cfg path exists
  rm -rf "$CFG_PATH"
  printf -- 'config: file' >"$template"
  run "$bin" template render "$template"

  assertTrue 'render command errored' "$status"
  assertEquals 'config: file' "$(cat "$stdout")"
  assertNull "$(cat "$stderr")"
}

testTemplateTokenWithNonexistantCfgPath() {
  # Ensure no cfg path exists
  rm -rf "$CFG_PATH"
  printf -- '# @@TEMPLATE@@\nconfig: file' >"$template"
  run "$bin" template render "$template"

  assertTrue 'render command errored' "$status"
  assertTrue "cat $stdout | head -n 1 \
    | grep -E '^# Generated from /.*/template\.'"
  assertNull "$(cat "$stderr")"
}

testReplacesValidTokens() {
  "$bin" config set foo bar >/dev/null
  "$bin" config set file /path/to/file >/dev/null
  "$bin" config set neverused nope >/dev/null
  printf -- '# @@TEMPLATE@@
root: @@file@@
fooness: @@foo@@
end_of_@@foo@@_the_line: true
amibroke: @@maybe@@
' >"$template"

  run "$bin" template render "$template"

  assertTrue 'render command errored' "$status"
  assertTrue "cat $stdout | head -n 1 \
    | grep -E '^# Generated from /.*/template\.'"
  assertEquals 'root: /path/to/file
fooness: bar
end_of_bar_the_line: true
amibroke: @@maybe@@' "$(tail -n +2 "$stdout")"
  assertNull "$(cat "$stderr")"
}

testWritesRenderedFile() {
  "$bin" config set foo bar >/dev/null
  "$bin" config set file /path/to/file >/dev/null
  "$bin" config set neverused nope >/dev/null
  printf -- '# @@TEMPLATE@@
root: @@file@@
fooness: @@foo@@
end_of_@@foo@@_the_line: true
amibroke: @@maybe@@
' >"$template"
  printf -- 'root: /path/to/file
fooness: bar
end_of_bar_the_line: true
amibroke: @@maybe@@
' >"$expected"

  run "$bin" template render "$template" "$actual"

  assertTrue 'render command errored' "$status"
  assertTrue "cat $actual | head -n 1 \
    | grep -E '^# Generated from /.*/template\.'"
  assertEquals "$(cat "$expected")" "$(tail -n +2 "$actual")"
  assertNull "$(cat "$stdout")"
  assertNull "$(cat "$stderr")"
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
