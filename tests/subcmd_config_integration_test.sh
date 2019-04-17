#!/usr/bin/env sh

# shellcheck source=test_helpers.sh
. "${0%/*}/test_helpers.sh"

testAborts() {
  run "$bin" config

  assertNotEquals "$status" 0
  assertTrue "grepStderr '^USAGE:$'"
  assertTrue "grepStderr '^xxx missing argument$'"
}

testHelpSubcmd() {
  run "$bin" config help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testHelpFlagLong() {
  run "$bin" config --help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testHelpFlagShort() {
  run "$bin" config -h

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config)'"
  assertTrue "grepStdout '^USAGE:$'"
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
