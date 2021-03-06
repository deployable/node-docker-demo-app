# Docker Node.js Application Supervision

Examples of running a nodejs app under Docker with various process managers. 

- Plain Docker
- [supervisor](http://supervisord.org/)
- [s6](http://skarnet.org/software/s6/overview.html)
- [nodemon](https://nodemon.io/)
- [forever](https://github.com/foreverjs/forever)

Examples have both the Debian based [`node`](https://hub.docker.com/_/node) image and
 the Alpine [`mhart/alpine-node`](https://hub.docker.com/r/mhart/alpine-node) image using Node v8.9.3

The node app will run as `nobody` in each setup. 


## Plain Node + Docker

The app must handle the sigint (ctrl-c) and sigterm (`docker stop`) signals when running as PID 1 in Docker

    docker build -f Dockerfile.plain -t dply/node-docker-demo-app:plain .
    docker run -dp 8080:8080 --restart always dply/node-docker-demo-app:plain
    curl http://localhost:8080

## s6

Uses the [s6-overlay](https://github.com/just-containers/s6-overlay) project.

    docker build -f Dockerfile.s6 -t dply/node-docker-demo-app:s6 .
    docker run -dp 8080:8080 dply/node-docker-demo-app:s6
    curl http://localhost:8080

## forever

Forever doesn't handle sigint and sigterm when running a script in the foreground.

    docker build -f Dockerfile.plain -t dply/node-docker-demo-app:forever .
    docker run -dp 8080:8080 dply/node-docker-demo-app:forever
    curl http://localhost:8080

## nodemon

`-ti` is required to attach and control nodemon

    docker build -f Dockerfile.nodemon -t dply/node-docker-demo-app:nodemon .
    docker run -dtip 8080:8080 dply/node-docker-demo-app:nodemon
    curl http://localhost:8080

## supervisor

Supervisor is easy to configure and provides an XMLRPC API to programatically
manage your services running in Docker

    docker build -f Dockerfile.plain -t dply/node-docker-demo-app:supervisor .
    docker run -dp 8080:8080 dply/node-docker-demo-app:supervisor
    curl http://localhost:8080

## make.sh

The `./make.sh` script can build and run everything

The default is `./make.sh build`

`./make.sh build_s6`

`./make.sh run s6`

`./make.sh run s6-alpine`

`./make.sh test`

`./make.sh build plain`

`./make.sh run plain`

etc
