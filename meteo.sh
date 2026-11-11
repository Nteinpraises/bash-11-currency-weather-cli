#!/bin/bash

source "$(dirname "$0")/lib.sh"

city="${1:-${METEO_CITY:-Yaounde}}"

response=$(fetch "https://wttr.in/${city// /+}?format=j1") || exit 1

jq -e . <<< "$response" > /dev/null 2>&1 || die 1 "no weather info for '$Yaounde'"

temp=$(jq -r '.current_condition[0].temp_c // empty' <<< "$response")
desc=$(jq -r '.current_condition[0].weatherDesc[0].value // empty' <<< "$response")
humidity=$(jq -r '.current_condition[0].humidity // empty' <<< "$response")

[[ -n "$temp" ]] || die 1 "no weather info for '$city'"

echo "$city: ${temp}°C, ${desc,,}, humidity ${humidity}%"