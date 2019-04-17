#!/usr/bin/env sh

# shellcheck source=test_helpers.sh
. "${0%/*}/test_helpers.sh"

testAborts() {
  run "$bin" template render

  assertNotEquals "$status" 0
  assertTrue "grepStderr '^USAGE:$'"
  assertTrue "grepStderr '^xxx missing argument$'"
}

testHelpSubcmd() {
  run "$bin" template render help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template-render)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testHelpFlagLong() {
  run "$bin" template render --help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template-render)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testHelpFlagShort() {
  run "$bin" template render -h

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template-render)'"
  assertTrue "grepStdout '^USAGE:$'"
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
