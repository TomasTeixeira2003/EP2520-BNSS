# Stockholm

Configurations of the Stockholm site.

## Prerequisites

- `step` CLI tool ([help](https://smallstep.com/docs/step-cli/installation/))
- `/etc/hosts` configured to redirect `nextcloud.internal` to 127.0.0.1 in lieu of a DNS server

## Setup

1. Start the Certificate Authority

    ```bash
    cd ca
    ./gen_pw.sh
    docker compose up -d
    cd ..
    ```

2. Configure the TLS certificates of other containers

    ```bash
    ./install_certs.sh
    ```

3. Start the NextCloud service

    ```bash
    cd nextcloud
    docker compose up -d
    cd ..
    ```
