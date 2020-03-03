#!/usr/bin/env bash

set -x

# Install hex
mix local.hex --force

# Install the dependences
mix deps.get

# Install node dependences
yarn --cwd="assets" install

# db create && db migrate db seeds
mix ecto.reset

# run
mix phx.server