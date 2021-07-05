#!/usr/bin/env awk

BEGIN {
    input = ARGV[1]

    setup_vars()
    compile_source(input)
}

function compile_source(src) {
    while (getline <src > 0) {
        for (token in vars) {
            gsub(token, vars[token])
        }
        print
    }
}

function setup_vars(_arr, _size) {
    if (getline <"VERSION.txt" > 0) {
        vars["@@version@@"] = $1
    }
    if (NIGHTLY_BUILD) {
        _size = split(vars["@@version@@"], _arr, "-")
        vars["@@version@@"] = _arr[1] "-nightly." NIGHTLY_BUILD
    }
    if ((("git " "show -s --format=%H") | getline) > 0) {
        vars["@@commit_hash@@"] = $1
    }
    if ((("git " "show -s --format=%ad --date=short") | getline) > 0) {
        vars["@@commit_date@@"] = $1
    }
}
