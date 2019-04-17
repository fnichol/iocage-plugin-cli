#!/usr/bin/env sh

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

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testCmdHelpFlagLong() {
  run "$bin" --help

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testCmdHelpFlagShort() {
  run "$bin" -h

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testSubcmdConfigAborts() {
  run "$bin" config

  assertNotEquals "$status" 0
  assertTrue "grepStderr '^USAGE:$'"
  assertTrue "grepStderr '^xxx missing argument$'"
}

testSubcmdConfigHelpSubcmd() {
  run "$bin" config help

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testSubcmdConfigHelpFlagLong() {
  run "$bin" config --help

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testSubcmdConfigHelpFlagShort() {
  run "$bin" config -h

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr config)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testSubcmdServicesAborts() {
  run "$bin" services

  assertNotEquals "$status" 0
  assertTrue "grepStderr '^USAGE:$'"
  assertTrue "grepStderr '^xxx missing argument$'"
}

testSubcmdServicesHelpSubcmd() {
  run "$bin" services help

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testSubcmdServicesHelpFlagLong() {
  run "$bin" services --help

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testSubcmdServicesHelpFlagShort() {
  run "$bin" services -h

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr services)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testSubcmdTemplateAborts() {
  run "$bin" template

  assertNotEquals "$status" 0
  assertTrue "grepStderr '^USAGE:$'"
  assertTrue "grepStderr '^xxx missing argument$'"
}

testSubcmdTemplateHelpSubcmd() {
  run "$bin" template help

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testSubcmdTemplateHelpFlagLong() {
  run "$bin" template --help

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template)'"
  assertTrue "grepStdout '^USAGE:$'"
}

testSubcmdTemplateHelpFlagShort() {
  run "$bin" template -h

  assertTrue 'version command errored' "$status"
  assertTrue "cat $stdout | head -n 1 | grep -E '$(grepVerStr template)'"
  assertTrue "grepStdout '^USAGE:$'"
}

run() {
  # Implementation inspired by `run` in bats
  # See: https://github.com/bats-core/bats-core/blob/8789f91/libexec/bats-core/bats-exec-test#L58-L67
  _origFlags="$-"
  set +eET
  "$@" >"$stdout" 2>"$stderr"
  status=$?
  set "-$_origFlags"
  unset _origFlags

  return "$status"
}

grepStdout() {
  grep -E "$1" <"$stdout"
}

grepStderr() {
  grep -E "$1" <"$stderr"
}

grepVerStr() {
  if [ -n "${1:-}" ]; then
    echo "plugin-$1 [0-9]+\.[0-9]+\.[0-9]+$"
  else
    echo "plugin [0-9]+\.[0-9]+\.[0-9]+$"
  fi
}

oneTimeSetUp() {
  set -u
  bin="${0%/*}/../bin/plugin"
  stdout="$SHUNIT_TMPDIR/stdout"
  stderr="$SHUNIT_TMPDIR/stderr"
}

setUp() {
  rm -f "$stdout" "$stderr"
  unset status
}

# shellcheck disable=SC1090
. "${0%/*}/../tmp/shunit2/shunit2"
