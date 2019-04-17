#!/usr/bin/env sh

# shellcheck source=test_helpers.sh
. "${0%/*}/test_helpers.sh"

testAborts() {
  run "$bin" config get

  assertNotEquals 0 "$status"
  assertTrue "grepStderr '^USAGE:$'"
  assertTrue "grepStderr '^xxx missing argument$'"
}

testHelpSubcmd() {
  run "$bin" config get help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config-get)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testHelpFlagLong() {
  run "$bin" config get --help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config-get)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testHelpFlagShort() {
  run "$bin" config get -h

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config-get)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testGetNonexistantCfgPath() {
  # Ensure no cfg path exists
  rm -rf "$CFG_PATH"
  run "$bin" config get nope

  assertNotEquals 0 "$status"
  assertTrue "grepStderr '^xxx config key not found;'"
  assertNull "$(cat "$stdout")"
}

testGetNoSuchKey() {
  # Simulate a created but empty metadata set
  mkdir -p "$CFG_PATH"
  run "$bin" config get nope

  assertNotEquals 0 "$status"
  assertTrue "grepStderr '^xxx config key not found;'"
  assertNull "$(cat "$stdout")"
}

testGetExistingKeyManuallySetup() {
  # Simulate an existing metadata set
  mkdir -p "$CFG_PATH"
  echo 'bar' >"$CFG_PATH/foo"
  run "$bin" config get foo

  assertTrue 'get command errored' "$status"
  assertEquals "bar" "$(cat "$stdout")"
  assertNull "$(cat "$stderr")"
}

testGetExistingKey() {
  # Use `config set` to set the metadata
  "$bin" config set foo bar >/dev/null
  run "$bin" config get foo

  assertTrue 'get command errored' "$status"
  assertEquals "bar" "$(cat "$stdout")"
  assertNull "$(cat "$stderr")"
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
