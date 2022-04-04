#!/usr/bin/env bash

# exit on error
set -o errexit

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
(cd assets && yarn install)
(cd assets && yarn run build:css)
(cd assets && yarn run build:js)

# Build the release and overwrite the existing release directory
MIX_ENV=prod mix release --overwrite

# Migrate the new app
_build/prod/rel/tapio/bin/tapio eval 'Tapio.ReleaseTasks.Migrate.run()'
