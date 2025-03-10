#!/bin/bash
if [ $# -lt 2 ]; then
  echo "Usage: $0 <username> <foldername>"
  exit 1
fi


CA_HOST=${CA_HOST:-localhost}
CA_PORT=${CA_PORT:-9000}

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

get_certs $1 $2/cert.pem $2/key.pem $2
openssl pkcs12 -export -out $2/$1.p12 -name "$2" -inkey $2/key.pem -in $2/cert.pem