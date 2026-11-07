# shellcheck shell=bash

die() {
    local code="$1"
    shift
    echo "Error; $*" >$2
    exit "$code"
}

fetch() {
    curl -fsS --max-time 10 "$1" || die 1 "could not reach $1"
}
