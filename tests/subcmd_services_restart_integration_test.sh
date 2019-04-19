#!/usr/bin/env sh

# shellcheck source=tests/test_helpers.sh
. "${0%/*}/test_helpers.sh"

testHelpSubcmd() {
  run "$bin" services restart help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services-restart)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagLong() {
  run "$bin" services restart --help

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services-restart)'"
  assertStdoutContains '^USAGE:$'
}

testHelpFlagShort() {
  run "$bin" services restart -h

  assertTrue 'help command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services-restart)'"
  assertStdoutContains '^USAGE:$'
}

testNonexistantCfgPath() {
  # Ensure no cfg path exists
  rm -rf "$CFG_PATH"
  run "$bin" services restart

  assertTrue 'get command errored' "$status"
  assertEquals 'no services to restart, done.' "$(cat "$stdout")"
  assertNull "$(cat "$stderr")"
}

testSingleService() {
  fakeServiceProgram
  printf -- "service called; args=myapp restart\n" >"$expected"
  "$bin" services set myapp >/dev/null
  run "$bin" services restart

  assertTrue 'get command errored' "$status"
  assertEquals "$(cat "$expected")" "$(cat "$stdout")"
  assertNull "$(cat "$stderr")"
}

testMultipleServices() {
  fakeServiceProgram
  printf -- "service called; args=un restart
service called; args=deux restart
service called; args=trois restart
" >"$expected"
  "$bin" services set un deux trois >/dev/null
  run "$bin" services restart

  assertTrue 'get command errored' "$status"
  assertEquals "$(cat "$expected")" "$(cat "$stdout")"
  assertNull "$(cat "$stderr")"
}

testFailingSingleService() {
  fakeServiceProgram
  "$bin" services set bomb >/dev/null
  run "$bin" services restart

  assertNotEquals 0 "$status"
  assertEquals 'someone set us up the bomb.' "$(cat "$stderr")"
  assertNull "$(cat "$stdout")"
}

testFailingSingleServiceWithMultipleServices() {
  fakeServiceProgram
  printf -- "service called; args=un restart
service called; args=deux restart
" >"$expected"
  "$bin" services set un deux bomb trois >/dev/null
  run "$bin" services restart

  assertNotEquals 0 "$status"
  assertEquals 'someone set us up the bomb.' "$(cat "$stderr")"
  assertEquals "$(cat "$expected")" "$(cat "$stdout")"
}

fakeServiceProgram() {
  mkdir -p "$fakebinpath"
  # Create a fake program `service` to be called instead of the real program
  # shellcheck disable=SC2016
  echo '#!/usr/bin/env sh
if [ "$1" = "bomb" ]; then
  echo "someone set us up the bomb." >&2
  exit 1
else
  echo "service called; args=$@"
fi
' >"$fakebinpath/service"
  chmod 0755 "$fakebinpath/service"
  # Insert the fake program at the start of `$PATH` so it gets called
  PATH="$fakebinpath:$PATH"
}

oneTimeSetUp() {
  commonOneTimeSetUp
}

setUp() {
  commonSetUp
}

. "$shunit2"
