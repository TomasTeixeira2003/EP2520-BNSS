# Synapse Debugging

Source: <https://github.com/element-hq/synapse/tree/develop/contrib/docker>

```shell
docker-compose run --rm -e SYNAPSE_SERVER_NAME=chat.internal -e SYNAPSE_REPORT_STATS=yes synapse generate
```

(This will also generate necessary signing keys.)

Then, customize your configuration and run the server:

```shell
docker-compose up -d
```

Create test user:

```shell
docker compose exec -it synapse bash
register_new_matrix_user -c /data/homeserver.yaml http://localhost:8008
```

The Element client can be used for testing without installing anything, accessible at <https://app.element.io/>. Make sure to change the homeserver during signin to the local homeserver.
