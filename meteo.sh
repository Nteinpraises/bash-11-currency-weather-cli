#!/bin/bash

# meteo.sh - show the current weather for a city

# shellcheck disable=SC1091
source "$(dirname "$0")/lib.sh"

city="${1:-${METEO_CITY:-Yaounde}}"

response=$(fetch "https://wttr.in/${city// /+}?format=j1") || exit 1

jq -e . <<< "$response" > /dev/null 2>&1 || die 1 "no weather info for '$city'"

temp=$(jq -r '.current_condition[0].temp_C // empty' <<< "$response")
desc=$(jq -r '.current_condition[0].weatherDesc[0].value // empty' <<< "$response")
humidity=$(jq -r '.current_condition[0].humidity // empty' <<< "$response")

[[ -n "$temp" ]] || die 1 "no weather info for '$city'"

echo "$city: ${temp}°C, ${desc,,}, humidity ${humidity}%"