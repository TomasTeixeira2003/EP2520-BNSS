# Stockholm

Configurations of the Stockholm site.

## Prerequisites

- `step` CLI tool ([help](https://smallstep.com/docs/step-cli/installation/))
- Your DNS server in `/etc/resolv.conf` (or wherever your OS stores it) should be set to 127.0.0.1

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

3. Start the DNS service

    ```bash
    docker compose up -d
    ```

4. Start the NextCloud service

    ```bash
    cd nextcloud
    docker compose up -d
    cd ..
    ```
