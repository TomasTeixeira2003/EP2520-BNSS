```
docker build -t radius-ACME -f Dockerfile.freeRADIUS .
```

```
docker run --rm -d --name radius-ACME -p 1812-1813:1812-1813/udp radius-ACME
```

[Documentation](https://hub.docker.com/r/freeradius/freeradius-server)
