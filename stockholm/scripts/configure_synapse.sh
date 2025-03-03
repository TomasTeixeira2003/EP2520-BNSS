#!/usr/bin/env bash

# Generates the Synapse configuration called homeserver.yaml,
# optionally adding support for Keycloak authentication.
KC_REALM=${KC_REALM:-master}
KC_HOST=${KC_HOST:-keycloak.internal}

# Check if volume already has the homeserver file generated
if ! docker compose run --rm --entrypoint "/bin/bash -c 'ls /data/homeserver.yaml'" synapse /data/homeserver.yaml; then
  # No, generate it fresh
  docker compose run --rm -e SYNAPSE_SERVER_NAME=chat.internal -e SYNAPSE_REPORT_STATS=yes synapse generate
  echo "Generated /data/homeserver.yaml on the volume."
fi

if [ "$KC_CLIENT_SECRET" ]; then
  # TODO Check if the config already has Keycloak configured
  # docker compose run --entrypoint "cat << EOF >> /data/homeserver.yaml" synapse

  # create tmpfile to write the credentials
  tmpfile=$(mktemp)
  trap 'rm -f "${tmpfile}"' EXIT
  cat << EOF >> ${tmpfile}

oidc_providers:
  - idp_id: keycloak
    idp_name: "ACME Keycloak"
    issuer: "https://${KC_HOST}/realms/${KC_REALM}"
    client_id: "synapse"
    client_secret: "$KC_CLIENT_SECRET"
    scopes: ["openid", "profile"]
    user_mapping_provider:
      config:
        localpart_template: "{{ user.preferred_username }}"
        display_name_template: "{{ user.name }}"
    backchannel_logout_enabled: true # Optional
EOF
  # temporarily start a container to be able to copy the file to its volume
  docker compose run -d --rm --name synapse-tmp --entrypoint "tail -f /dev/null" synapse
  docker cp ${tmpfile} synapse-tmp:/data/oidc-config.yaml
  docker container stop synapse-tmp
  # append oidc config to homeserver config
  docker compose run --rm --entrypoint sh synapse -c 'cat /data/oidc-config.yaml >> /data/homeserver.yaml'

else
  echo "warning: KC_CLIENT_SECRET not found in env, setting synapse up without Keycloak configuration."
  echo "Run this script again with the KC_CLIENT_SECRET defined to add Keycloak. More info: https://element-hq.github.io/synapse/latest/openid.html#keycloak"
  exit 0
fi
