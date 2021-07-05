#!/usr/bin/env sh

# shellcheck source=tests/test_helpers.sh
. "${0%/*}/test_helpers.sh"

testAborts() {
  run "$bin" template

  assertNotEquals "$return_status" 0
  assertStderrContains '^USAGE:$'
  assertStderrContains '^xxx missing argument$'
}

testHelpSubcmd() {
  run "$bin" template help

  assertTrue 'help command errored' "$return_status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagLong() {
  run "$bin" template --help

  assertTrue 'help command errored' "$return_status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagShort() {
  run "$bin" template -h

  assertTrue 'help command errored' "$return_status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template)'"
  assertStdoutContains '^USAGE:$'
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
