#!/usr/bin/env sh
# shellcheck disable=SC2119

# shellcheck source=test_helpers.sh
. "${0%/*}/test_helpers.sh"

testCmdAborts() {
  run "$bin"

  assertNotEquals "$status" 0
  assertStderrContains '^USAGE:$'
  assertStderrContains '^xxx missing argument$'
}

testCmdVersionSubcmd() {
  run "$bin" version

  assertTrue 'version command errored' "$status"
  assertStdoutContains "$(grepVerStr)"
}

testCmdVersionFlagLong() {
  run "$bin" --version

  assertTrue 'version command errored' "$status"
  assertStdoutContains "$(grepVerStr)"
}

testCmdVersionFlagShort() {
  run "$bin" -v

  assertTrue 'version command errored' "$status"
  assertStdoutContains "$(grepVerStr)"
}

testCmdHelpSubcmd() {
  run "$bin" help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr)'"
  assertStdoutContains '^USAGE:$'
}

testCmdHelpFlagLong() {
  run "$bin" --help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr)'"
  assertStdoutContains '^USAGE:$'
}

testCmdHelpFlagShort() {
  run "$bin" -h

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr)'"
  assertStdoutContains '^USAGE:$'
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
