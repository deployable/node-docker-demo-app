# node-docker-app

A simple demo node app in docker with various internal supervisor setups

- plain
- [supervisor](http://supervisord.org/)
- [s6](https://github.com/just-containers/s6-overlay)
- [forever](https://github.com/foreverjs/forever)

## Plain

    docker build -f Dockerfile.plain -t node-service-plain .
    docker run -p 8080:8080 node-service-plain
    curl http://localhost:8080

## s6

    docker build -f Dockerfile.s6 -t node-service-s6 .
    docker run -p 8080:8080 node-service-s6
    curl http://localhost:8080

## forever

    docker build -f Dockerfile.plain -t node-service-forever .
    docker run -p 8080:8080 node-service-forever
    curl http://localhost:8080

## supervisor

    docker build -f Dockerfile.plain -t node-service-supervisor .
    docker run -p 8080:8080 node-service-supervisor
    curl http://localhost:8080

