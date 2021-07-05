#!/usr/bin/env sh

# shellcheck source=tests/test_helpers.sh
. "${0%/*}/test_helpers.sh"

testAborts() {
  run "$bin" services

  assertNotEquals "$return_status" 0
  assertStderrContains '^USAGE:$'
  assertStderrContains '^xxx missing argument$'
}

testHelpSubcmd() {
  run "$bin" services help

  assertTrue 'help command errored' "$return_status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagLong() {
  run "$bin" services --help

  assertTrue 'help command errored' "$return_status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagShort() {
  run "$bin" services -h

  assertTrue 'help command errored' "$return_status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services)'"
  assertStdoutContains '^USAGE:$'
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
