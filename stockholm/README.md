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

4. Start the Keycloak service

    ```bash
    cd keycloak
    docker compose up -d
    cd ..
    ```

    Use the web UI to add a new realm, a new Client for Nextcloud and a new User that will be able to log in. - https://www.keycloak.org/docs/latest/server_admin/index.html
    
    Admin account for Keycloak is defined in the KEYCLOAK_ADMIN, KEYCLOAK_ADMIN_PASSWORD environment variables


5. Start the NextCloud service

    ```bash
    cd nextcloud
    docker compose up -d
    cd ..
    ```

    Add our CA certificate to the nextcloud's trusted certificates.
    
    ```bash
    ./add_ca_cert_to_nc_trusted.sh
    ```
    <br/>
    Install the OpenID Connect user backend app in Nextcloud.<br/>
    In Administration settings, select OpenID Connect.<br/>
    Register Keycloud as a provider.
    You will need the ClientID and secret that was created in Keycloak for the Nextcloud client, as well as the discovery endpoint.<br/><br/>
    The discovery endpoint has the following format: <br/><br/>

    https://{KEYCLOAK_HOST}:{KEYCLOAK_PORT}/realms/{REALM}/.well-known/openid-configuration.
    
