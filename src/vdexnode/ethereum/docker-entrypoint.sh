#!/bin/bash -e

set -o errexit      # make your script exit when a command fails.
set -o nounset      # exit when your script tries to use undeclared variables.

/ethereum/parity --config /ethereum/config.toml
