#!/usr/bin/env bash

docker cp ./ca/certs/roots.pem nextcloud-aio-nextcloud:/etc/ssl/certs/roots.pem
docker exec --user www-data -it nextcloud-aio-nextcloud php occ security:certificates:import /etc/ssl/certs/roots.pem