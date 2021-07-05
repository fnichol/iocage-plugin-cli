#!/usr/bin/env sh

run() {
  # Implementation inspired by `run` in bats
  # See: https://git.io/fjCcr
  _origFlags="$-"
  set +e
  # functrace is not supported by all shells, eg: dash
  if set -o | "${GREP:-grep}" -q '^functrace'; then
    # shellcheck disable=SC2039
    set +T
  fi
  # errtrace is not supported by all shells, eg: ksh
  if set -o | "${GREP:-grep}" -q '^errtrace'; then
    # shellcheck disable=SC2039
    set +E
  fi
  "$@" >"$stdout" 2>"$stderr"
  return_status=$?
  set "-$_origFlags"
  unset _origFlags

  return "$return_status"
}

assertStdoutContains() {
  assertTrue "grep -E '$1' <'$stdout'"
}

assertStderrContains() {
  assertTrue "grep -E '$1' <'$stderr'"
}

grepVerStr() {
  if [ -n "${1:-}" ]; then
    echo "plugin-$1 [0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.-]+)?$"
  else
    echo "plugin [0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.-]+)?$"
  fi
}

# shellcheck disable=SC2034
commonOneTimeSetUp() {
  set -u

  __ORIG_PATH="$PATH"

  bin="${0%/*}/../build/plugin"

  tmppath="$SHUNIT_TMPDIR/tmp"

  stdout="$tmppath/stdout"
  stderr="$tmppath/stderr"
  expected="$tmppath/expected"
  actual="$tmppath/actual"
  template="$tmppath/template"

  fakebinpath="$SHUNIT_TMPDIR/fakebin"

  CFG_PATH="$SHUNIT_TMPDIR/cfg_path"
  export CFG_PATH
}

commonSetUp() {
  # Reset the value of `$PATH` to its original value
  PATH="$__ORIG_PATH"
  # Clean any prior test file/directory state
  rm -rf "$tmppath" "$fakebinpath" "$CFG_PATH"
  # Unset any prior test variable state
  unset status
  # Create a scratch directory that will be removed on every test
  mkdir -p "$tmppath"
}

# shellcheck disable=SC2034
shunit2="${0%/*}/../tmp/shunit2/shunit2"
