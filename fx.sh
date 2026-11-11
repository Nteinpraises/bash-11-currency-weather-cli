#!/bin/bash

source "$(dirname "$0")/lib.sh"

if [[ $# -ne 3 ]]; then
    die 2 "usage: $0 AMOUNT(e.g 5000) FROM(e.g EUR) TO(e.g XAF)"
fi

amount="$1"
from="${2^^}"
to="${3^^}"

[[ "$amount" =~ ^[0-9]+([.][0-9]+)?$ ]] || die 2 "amount must be a number, like 250 or 12.5"
awk -v a="$amount" 'BEGIN { exit !(a > 0) }' || die 2 "amount must be greater than zero"
[[ "$from" =~ ^[A-Z]{3}$ ]] || die 2 "currency code must be 3 letters, got '$2'"
[[ "$to" =~ ^[A-Z]{3}$ ]] || die 2 "currency code must be 3 letters, got '$3'"

response=$(fetch "https://open.er-api.com/v6/latest/$from") || exit 1

result=$(jq -r '.result' <<< "$response")

if [[ "$result" != "success" ]]; then
    reason=$(jq -r '."error-type" // "unknown error"' <<< "$response")
    if [[ "$reason" == "unsupported-code" ]]; then
        die 2 "unknown currency '$from'"
    fi
    die 1 "the rate service returned an error: $reason"
fi

rate=$(jq -r --arg to "$to" '.rates[$to] // empty' <<< "$response")
[[ -n "$rate" ]] || die 2 "unknown currency '$to'"

converted=$(awk -v a="$amount" -v r="$rate" 'BEGIN { printf "%.2f", a * r }')

echo "$amount $from = $converted $to   (rate $rate)"