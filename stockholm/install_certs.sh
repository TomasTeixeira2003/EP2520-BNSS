#!/usr/bin/env bash
set -e

# TODO central config
NC_HOST=${NC_HOST:-nextcloud.internal}
KC_HOST=${KC_HOST:-keycloak.internal}

CA_HOST=${CA_HOST:-localhost}
CA_PORT=${CA_PORT:-9000}

cert_dir="./ca/certs/roots.pem"
echo "Downloading root certificate and placing it in ${cert_dir}"
mkdir -p ca/certs
curl -fk https://${CA_HOST}:${CA_PORT}/roots.pem > ca/certs/roots.pem

function get_certs {
    hostname=$1
    certpath=$2
    keypath=$3
    certsdir=$4

    token=$(step ca token ${hostname} --ca-url https://${CA_HOST}:${CA_PORT} --root ca/certs/roots.pem --password-file ca/password.txt)
    mkdir -p ${certsdir}
    step ca certificate --token ${token} ${hostname} ${certpath} ${keypath}
    cp ca/certs/roots.pem ${certsdir}
}

get_certs ${NC_HOST} nextcloud/certs/cert.pem nextcloud/certs/key.pem nextcloud/certs
get_certs ${KC_HOST} keycloak/certs/cert.pem keycloak/certs/key.pem keycloak/certs
