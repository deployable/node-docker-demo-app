# Supervision of Docker Node.js app

A simple demo node app running in Docker with various supervisor setups.
Examples on on both the Debian based [node](https://hub.docker.com/_/node)  image and
 the Alpine [mhart/alpine-node](https://hub.docker.com/r/mhart/alpine-node) image.

- Plain Docker
- [supervisor](http://supervisord.org/)
- [s6](https://github.com/just-containers/s6-overlay)
- [forever](https://github.com/foreverjs/forever)

## Plain

The app must handle the sigint (ctrl-c) and sigterm (`docker stop`) signals when running as PID 1 in Docker

    docker build -f Dockerfile.plain -t node-service-plain .
    docker run -p 8080:8080 node-service-plain
    curl http://localhost:8080

## s6

    docker build -f Dockerfile.s6 -t node-service-s6 .
    docker run -p 8080:8080 node-service-s6
    curl http://localhost:8080

## forever

Foever doesn't handle sigint and sigterm when running a script in the foreground

    docker build -f Dockerfile.plain -t node-service-forever .
    docker run -p 8080:8080 node-service-forever
    curl http://localhost:8080

## supervisor

    docker build -f Dockerfile.plain -t node-service-supervisor .
    docker run -p 8080:8080 node-service-supervisor
    curl http://localhost:8080

