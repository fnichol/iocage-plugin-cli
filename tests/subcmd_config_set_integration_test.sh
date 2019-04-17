#!/usr/bin/env sh

# shellcheck source=test_helpers.sh
. "${0%/*}/test_helpers.sh"

testAborts() {
  run "$bin" config set

  assertNotEquals "$status" 0
  assertTrue "grepStderr '^USAGE:$'"
  assertTrue "grepStderr '^xxx missing argument$'"
}

testHelpSubcmd() {
  run "$bin" config set help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config-set)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testHelpFlagLong() {
  run "$bin" config set --help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config-set)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testHelpFlagShort() {
  run "$bin" config set -h

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config-set)'"
  assertTrue "grepStdout '^USAGE:$'"
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
