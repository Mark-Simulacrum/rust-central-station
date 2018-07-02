#!/bin/bash

# Initial deployment instructions:
#
#    mkdir -p /opt/rcs/logs/nginx /opts/rcs/data/letsencrypt
#    # copy secrets.toml.example to /opt/rcs/data and configure it
#
# And... I think that's it!
#
#
# This script should be run on RCS itself. It was written by @aidanhs
# and lives here: https://github.com/aidanhs/simpleinfra/blob/master/restart-rcs.sh

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

cd /opt/rcs
(test -d data || (echo "no data dir" && exit 1))
docker pull alexcrichton/rust-central-station
(docker rm -f rcs || true)
docker run \
    --name rcs \
    --volume `pwd`/data:/data \
    --volume `pwd`/data/letsencrypt:/etc/letsencrypt \
    --volume `pwd`/logs:/var/log \
    --publish 80:80 \
    --publish 443:443 \
    --rm \
    --detach \
    alexcrichton/rust-central-station
