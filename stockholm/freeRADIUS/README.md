Run the following command to build the image:

```
docker build -t my-radius-image -f Dockerfile .
```

Run the following command to start the docker container:
```
docker run --name my-radius -p 1812-1813:1812-1813/udp my-radius-image -X
```

The freeRadius server will run in debug mode which allows the administrator to better understand what is happening.

The CA certificate in raddb/certs should be the CA that signs all user certificates.