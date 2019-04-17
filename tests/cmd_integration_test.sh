#!/usr/bin/env sh
# shellcheck disable=SC2119

# shellcheck source=test_helpers.sh
. "${0%/*}/test_helpers.sh"

testCmdAborts() {
  run "$bin"

  assertNotEquals "$status" 0
  assertTrue "grepStderr '^USAGE:$'"
  assertTrue "grepStderr '^xxx missing argument$'"
}

testCmdVersionSubcmd() {
  run "$bin" version

  assertTrue 'version command errored' "$status"
  assertTrue "grepStdout $(grepVerStr)"
}

testCmdVersionFlagLong() {
  run "$bin" --version

  assertTrue 'version command errored' "$status"
  assertTrue "grepStdout $(grepVerStr)"
}

testCmdVersionFlagShort() {
  run "$bin" -v

  assertTrue 'version command errored' "$status"
  assertTrue "grepStdout $(grepVerStr)"
}

testCmdHelpSubcmd() {
  run "$bin" help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testCmdHelpFlagLong() {
  run "$bin" --help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testCmdHelpFlagShort() {
  run "$bin" -h

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr)'"
  assertTrue "grepStdout '^USAGE:$'"
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
