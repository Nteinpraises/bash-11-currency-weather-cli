# Currency and Weather CLI

Two Bash scripts that talk to the internet: `fx.sh` converts currencies with live exchange rates, and `meteo.sh` shows the current weather for a city.

## Problem Statement

Freelancers in Cameroon are often paid in dollars or euros and plan their
day around the rain. These scripts answer both questions from the terminal
in one command.

## Tech Stack

- Bash
- curl, jq and awk
- Exchange rates from open.er-api.com and weather from wttr.in
- Git and GitHub (feature branch and pull request workflow)

## Installation

```bash
sudo apt install curl jq
git clone https://github.com/Nteinpraises/bash-11-currency-weather-cli.git
cd bash-11-currency-weather-cli
chmod +x fx.sh meteo.sh
```

## fx.sh

```bash
./fx.sh AMOUNT FROM TO
```

Currency codes work in any case. The amount must be a positive number, and
decimals are allowed. The result shows the converted amount with 2 decimals
and the rate used.

```text
$ ./fx.sh 100 EUR XAF
100 EUR = 65595.70 XAF   (rate 655.957)
```

Most rates change every day, so your numbers will differ.

## meteo.sh

```bash
./meteo.sh [CITY]
```

The city is the argument if given, otherwise the `METEO_CITY` variable,
otherwise Yaounde. City names with spaces work.

```text
$ ./meteo.sh Buea
Buea: 17°C, light drizzle, humidity 93%
```

## Shared Helpers

`lib.sh` holds the helpers that both scripts load with `source`: `die`
prints an error and stops with a chosen exit code, and `fetch` wraps
`curl -fsS --max-time 10`.

## Exit Codes

- 0: success
- 1: no network, a timeout or a service error
- 2: bad input, such as a non-numeric amount, a code that is not 3 letters or an unknown currency

```text
$ ./fx.sh abc USD XAF; echo $?
Error: amount must be a number, like 250 or 12.5
2
```

With the network switched off:

```text
$ ./fx.sh 100 EUR XAF; echo $?
curl: (6) Could not resolve host: open.er-api.com
Error: request to https://open.er-api.com/v6/latest/EUR failed (it was either a network problem, timeout or rejected request)
1
```

## How to Test It

```bash
./fx.sh 100 eur xaf
./fx.sh abc USD XAF; echo $?
./fx.sh 10 USD ZZZ; echo $?
./meteo.sh
./meteo.sh "Buea"
```

To test the network error, turn off Wi-Fi and run `./fx.sh 100 EUR XAF; echo $?`.
It must print a clear error and exit with status 1.

## Known Limits

- Rates are updated once a day by the free service.
- The weather service answers an unknown city with an error, so the script reports a failed request and exits with status 1.
- Accents and special characters in city names are not specially encoded.

## Author

Ntein Praises
