# Sample Docker Node.js app

A simple demo node app running in docker with various upervisor setups

- plain
- [supervisor](http://supervisord.org/)
- [s6](https://github.com/just-containers/s6-overlay)
- [forever](https://github.com/foreverjs/forever)

## Plain

The app must handle sigint and sigterm when running as PID 1 in Docker

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

