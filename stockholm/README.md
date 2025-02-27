# Stockholm

Configurations of the Stockholm site.

## Prerequisites

- `step` CLI tool ([help](https://smallstep.com/docs/step-cli/installation/))
- Copy `.env.example` into `.env`, and set a value for all environment variables
- Your DNS server in `/etc/resolv.conf` (or wherever your OS stores it) should be set to 127.0.0.1
    > NOTE: For local debugging, you may also add the hosts defined in .env to your `/etc/hosts`.
    >
    > example: `127.0.0.1   nextcloud.internal chat.internal keycloak.internal`
    >
    > This removes the need for the configuration of a DNS server.

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
    ./scripts/install_certs.sh
    ```

    > NOTE: You must add the root certificate of the CA to your system's
    > and your browser's *trust store* to make your software trust the services.
    > This certificate is found at `ca/certs/roots.pem`

3. Generate the homeserver configuration for Synapse

    ```bash
    docker compose run --rm -e SYNAPSE_SERVER_NAME=chat.internal -e SYNAPSE_REPORT_STATS=yes synapse generate
    ```

    For more on testing Synapse, check `./scripts/SYNAPSE.md`.

4. Start the services

    You should now be good to go.

    ```bash
    docker compose up -d
    ```

5. Configure NextCloud

    NextCloud needs additional configuration, access its admin panel through `http://$YOUR_HOST_IP:8080` through a web browser, and follow the instructions.

## Configuring OpenID through Keycloak

For the services to be able to verify credentials using the centralized
Identity and Access Management (IAM) tool Keycloak, additional configuration steps
must be taken.

- NextCloud
    1. Create a client in Keycloak for NextCloud <https://www.keycloak.org/docs/latest/server_admin/index.html>.
    2. Use the included script to configure NextCloud to trust the private root CA's certificate.

        ```bash
        ./scripts/add_ca_cert_to_nc_trusted.sh
        ```

    3. Open the NextCloud dashboard, logging in as an admin

        - Install the [OpenID Connect user backend app](https://apps.nextcloud.com/apps/user_oidc) in Nextcloud.
        - In Administration settings, select OpenID Connect.
        - Register Keycloud as a provider.
        - You will need the ClientID and secret that was created in Keycloak for the Nextcloud client, as well as the discovery endpoint.
        - The discovery endpoint has the following format:

        `https://{KEYCLOAK_HOST}:{KEYCLOAK_PORT}/realms/{REALM}/.well-known/openid-configuration`
