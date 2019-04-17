#!/usr/bin/env sh

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

commonOneTimeSetUp() {
  set -u

  __ORIG_PATH="$PATH"

  # shellcheck disable=SC2034
  bin="${0%/*}/../bin/plugin"

  stdout="$SHUNIT_TMPDIR/stdout"
  stderr="$SHUNIT_TMPDIR/stderr"
  expected="$SHUNIT_TMPDIR/expected"

  fakebinpath="$SHUNIT_TMPDIR/fakebin"

  CFG_PATH="$SHUNIT_TMPDIR/cfg_path"
  export CFG_PATH
}

commonSetUp() {
  # Reset the value of `$PATH` to its original value
  PATH="$__ORIG_PATH"
  # Clean any prior test file/directory state
  rm -rf "$stdout" "$stderr" "$expected" "$fakebinpath" "$CFG_PATH"
  # Unset any prior test variable state
  unset status
}

# shellcheck disable=SC2034
shunit2="${0%/*}/../tmp/shunit2/shunit2"
