#!/usr/bin/env sh

# shellcheck source=test_helpers.sh
. "${0%/*}/test_helpers.sh"

testAborts() {
  run "$bin" config set

  assertNotEquals 0 "$status"
  assertStderrContains '^USAGE:$'
  assertStderrContains '^xxx missing key argument$'
}

testHelpSubcmd() {
  run "$bin" services set help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services-set)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagLong() {
  run "$bin" services set --help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services-set)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagShort() {
  run "$bin" services set -h

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services-set)'"
  assertStdoutContains '^USAGE:$'
}

testMissingArgs() {
  run "$bin" services set

  assertNotEquals 0 "$status"
  assertStderrContains '^USAGE:$'
  assertStderrContains '^xxx missing argument$'
}

testSetNonexistantCfgPath() {
  # Ensure no cfg path exists
  rm -rf "$CFG_PATH"
  run "$bin" services set musicd

  assertTrue 'set command errored' "$status"
  assertStdoutContains '^services set;'
  assertNull "$(cat "$stderr")"
  assertEquals 'musicd' "$(cat "$CFG_PATH/__plugin_services")"
}

testSetSingleService() {
  run "$bin" services set cooldb

  assertTrue 'get command errored' "$status"
  assertStdoutContains '^services set;'
  assertNull "$(cat "$stderr")"
  assertEquals 'cooldb' "$(cat "$CFG_PATH/__plugin_services")"
}

testSetMultipleServices() {
  run "$bin" services set alpha beta charlie

  assertTrue 'get command errored' "$status"
  assertStdoutContains '^services set;'
  assertNull "$(cat "$stderr")"
  assertEquals 'alpha,beta,charlie' "$(cat "$CFG_PATH/__plugin_services")"
}

testSetOverwriteServices() {
  # Set an initial value
  "$bin" services set one two >/dev/null
  run "$bin" services set webd

  assertTrue 'set command errored' "$status"
  assertStdoutContains '^services set;'
  assertNull "$(cat "$stderr")"
  assertEquals 'webd' "$(cat "$CFG_PATH/__plugin_services")"
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
