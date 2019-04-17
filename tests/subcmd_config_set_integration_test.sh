#!/usr/bin/env sh

# shellcheck source=test_helpers.sh
. "${0%/*}/test_helpers.sh"

testAborts() {
  run "$bin" config set

  assertNotEquals 0 "$status"
  assertTrue "grepStderr '^USAGE:$'"
  assertTrue "grepStderr '^xxx missing key argument$'"
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

testMissingValueArg() {
  run "$bin" config set oops

  assertNotEquals 0 "$status"
  assertTrue "grepStderr '^USAGE:$'"
  assertTrue "grepStderr '^xxx missing value argument$'"
}

testSetNonexistantCfgPath() {
  # Ensure no cfg path exists
  rm -rf "$CFG_PATH"
  run "$bin" config set band 'bend sinister'

  assertTrue 'set command errored' "$status"
  assertTrue "grepStdout '^config key set;'"
  assertNull "$(cat "$stderr")"
  assertEquals 'bend sinister' "$(cat "$CFG_PATH/band")"
}

testSetNewKey() {
  run "$bin" config set song 'teacher'

  assertTrue 'set command errored' "$status"
  assertTrue "grepStdout '^config key set;'"
  assertNull "$(cat "$stderr")"
  assertEquals 'teacher' "$(cat "$CFG_PATH/song")"
}

testSetOverwriteKey() {
  # Set an initial value
  "$bin" config set song 'out of date' >/dev/null
  run "$bin" config set song 'fancy pants'

  assertTrue 'set command errored' "$status"
  assertTrue "grepStdout '^config key set;'"
  assertNull "$(cat "$stderr")"
  assertEquals 'fancy pants' "$(cat "$CFG_PATH/song")"
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
