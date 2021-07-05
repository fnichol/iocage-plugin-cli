#!/usr/bin/env sh

# shellcheck source=tests/test_helpers.sh
. "${0%/*}/test_helpers.sh"

testAborts() {
  run "$bin" config

  assertNotEquals "$return_status" 0
  assertStderrContains '^USAGE:$'
  assertStderrContains '^xxx missing argument$'
}

testHelpSubcmd() {
  run "$bin" config help

  assertTrue 'help command errored' "$return_status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagLong() {
  run "$bin" config --help

  assertTrue 'help command errored' "$return_status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagShort() {
  run "$bin" config -h

  assertTrue 'help command errored' "$return_status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config)'"
  assertStdoutContains '^USAGE:$'
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
