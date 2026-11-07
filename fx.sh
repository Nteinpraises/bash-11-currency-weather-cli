#!bin/bash

source "$(dirname "$0")/lib.sh"

if [[ $# -ne 3 ]]; then
    die 2 "Usage: $0 Amount from to"

fi

amount="$1"
from="${2^^}"
to="${3^^}"

[[ "$amount" =~ ^[0-9]+([.][0-9]+)?$ ]] || die 2 "amount must be a number, like 235 0r 14.2"
awk -v a="$amount" 'Begin { exit !(a>0) }' || die 2 "amount must be greater than zero"
[[ "$from" =~ ^[A-Z]{3}$ ]] || die 2 "currency code must be 3 letters, got '$2'"
[[ "$to" =~ ^[A-Z]{3}$ ]] || die 2 "currency code must be 3 letters, got '$3'"

echo "ok: $amount $from -----> $to"