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
    ./scripts/configure_synapse.sh
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

- Synapse

    1. Create a Client in Keycloak by following the [documentation](https://element-hq.github.io/synapse/latest/openid.html#keycloak).

    2. Then, after setting the `KC_CLIENT_SECRET` to the client secret, run the following script:

        ```shell
        KC_CLIENT_SECRET=${YOUR_SECRET_VALUE} ./scripts/configure_synapse.sh
        ```

- Secure Web Server
    1. Create a client in Keycloak for the Secure Web Server. \
        Use <https://secureweb.internal> as the Root URL and enable Client authentication. All other options are added by default

        For the 2 Factor Authentication to work we need to create a new Authentication Flow.\
        In Keycloak admin panel go to Authentication -> Flows. Then duplicate the browser built-in flow.\
        Edit the cloned flow.\
        Disable the Cookie.\
        In Browser 2FA Forms Alternative sub-flow, mark all child steps as Required.\
        In the client for the Secure Web Server, go to the Advanced tab.\
        At the bottom, on Authentication flow overrides options, select the flow that you configured as the Browser flow.
        

    2. Update the environment variables SW_CLIENT_ID and SW_CLIENT_SECRET with the values for the specific client
    3. Run the Apache Server through the central docker compose file.

- Connect OpenLDAP to Keycloak

  1. Vendor: `Other`
  2. Connection URL: `ldap://openldap:1389`
  3. Bind DN: `cn=<admin-user>,dc=acme,dc=internal`
  4. Bind credentials: `<admin-pw>`
  5. Edit mode: `WRITEABLE`
  6. Users DN: `ou=users,dc=acme,dc=internal`
  7. Username LDAP Attribute: `uid`
  8. RDN LDAP Attribute: `uid`
  