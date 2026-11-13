# shellcheck shell=bash

die() {
    local code="$1"
    shift
    echo "Error: $*" >&2
    exit "$code"
}

fetch() {
    curl -fsS --max-time 10 "$1" || die 1 "request to $1 failed (it was either a network problem, timeout or rejected request)"
}

