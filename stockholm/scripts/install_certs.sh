#!/usr/bin/env bash
set -e

# TODO central config
NC_HOST=${NC_HOST:-nextcloud.internal}
SY_HOST=${SY_HOST:-chat.internal}
KC_HOST=${KC_HOST:-keycloak.internal}
SW_HOST=${SW_HOST:-secureweb.internal}

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

get_certs ${NC_HOST} certs/nextcloud/cert.pem certs/nextcloud/key.pem certs/nextcloud
get_certs ${SY_HOST} certs/synapse/cert.pem certs/synapse/key.pem certs/synapse
get_certs ${KC_HOST} certs/keycloak/cert.pem certs/keycloak/key.pem certs/keycloak
get_certs ${SW_HOST} certs/secureweb/cert.pem certs/secureweb/key.pem certs/secureweb
