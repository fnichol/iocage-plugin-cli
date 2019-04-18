#!/usr/bin/env sh

# shellcheck source=test_helpers.sh
. "${0%/*}/test_helpers.sh"

testHelpSubcmd() {
  run "$bin" services get help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services-get)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagLong() {
  run "$bin" services get --help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services-get)'"
  assertStdoutContains '^USAGE:$'
}

testGetHelpFlagShort() {
  run "$bin" services get -h

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services-get)'"
  assertStdoutContains '^USAGE:$'
}

testGetNonexistantCfgPath() {
  # Ensure no cfg path exists
  rm -rf "$CFG_PATH"
  run "$bin" services get

  assertTrue 'get command errored' "$status"
  assertNull "$(cat "$stdout")"
  assertNull "$(cat "$stderr")"
}

testGetManuallySetup() {
  # Simulate an existing metadata set
  mkdir -p "$CFG_PATH"
  echo 'myapp' >"$CFG_PATH/__plugin_services"
  run "$bin" services get

  assertTrue 'get command errored' "$status"
  assertEquals 'myapp' "$(cat "$stdout")"
  assertNull "$(cat "$stderr")"
}

testGetSingleService() {
  "$bin" services set cooldb >/dev/null
  run "$bin" services get

  assertTrue 'get command errored' "$status"
  assertEquals 'cooldb' "$(cat "$stdout")"
  assertNull "$(cat "$stderr")"
}

testGetMultipleServices() {
  printf -- 'alpha\nbeta\ncharlie\ndelta\n' >"$expected"
  "$bin" services set alpha beta charlie delta >/dev/null
  run "$bin" services get

  assertTrue 'get command errored' "$status"
  assertEquals "$(cat "$expected")" "$(cat "$stdout")"
  assertNull "$(cat "$stderr")"
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
