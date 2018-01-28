#!/usr/bin/env bash

# Setup

set -uex -o pipefail

which greadlink >/dev/null 2>&1 && readlink=greadlink || readlink=readlink
rundir=$($readlink -f "${0%/*}")
cd $rundir


## Varibles

ARGS="$@"
[ -z "$ARGS" ] && set -- build
DOCKER_BUILD_PROXY=${DOCKER_BUILD_PROXY:-}
SCOPE="dply"
NAME="node-docker-demo-app"
SCOPE_NAME="${SCOPE}/${NAME}"
PORT=8080


## Builds

### Helpers

docker_build(){
  local tag=${1}
  args=""
  [ -z $DOCKER_BUILD_PROXY ] || args="$args --build-arg DOCKER_BUILD_PROXY=${DOCKER_BUILD_PROXY}"
  docker build $args -f "Dockerfile.$tag" -t ${SCOPE_NAME}:$tag .
}


### Commands

build(){
  build_plain
  build_forever
  build_nodemon
  build_s6
  build_supervisor
}

# plain
build_plain(){
  build_plain_node
  build_plain_alpine
}

build_plain_node(){
  docker_build plain
}

build_plain_alpine(){
  docker_build plain-alpine
}


# forever
build_forever(){
  build_forever_node
  build_forever_alpine
}

build_forever_node(){
  docker_build forever
}

build_forever_alpine(){
  docker_build forever-alpine
}


# nodemon
build_nodemon(){
  build_nodemon_node
  build_nodemon_alpine
}

build_nodemon_node(){
  docker_build nodemon
}

build_nodemon_alpine(){
  docker_build nodemon-alpine
}


# s6
build_s6(){
  build_s6_node
  build_s6_alpine
}

build_s6_node(){
  docker_build s6
}

build_s6_alpine(){
  docker_build s6-alpine
}


# supervisor
build_supervisor(){
  build_supervisor_node
  build_supervisor_alpine
}

build_supervisor_node(){
  docker_build supervisor
}

build_supervisor_alpine(){
  docker_build supervisor-alpine
}


## Run

run_update(){
  local version=$1
  # pre Docker 1.13 updates, when FROM couldnt be a variable
  #sed -i '' -e 's!^FROM node:.*-alpine!FROM node:'$version'-alpine!' Dockerfile.*-alpine
  #sed -i '' -e 's!^FROM node:[0-9\.]*$!FROM node:'$version'!' Dockerfile.[a-zA-Z0-9][a-zA-Z0-9]*
  sed -i '' -e 's!^ARG NODE_VERSION=".*"!ARG NODE_VERSION="'$version'"!' Dockerfile*
}

run_image(){
  local tag=${1:-plain}
  docker run -p "${PORT}:8080" "${SCOPE_NAME}:${tag}"
}

run(){
  run_image "$@"
}

## versions

versions(){
  versions_versions=$(curl -s https://nodejs.org/dist/index.json)
  echo "$versions_versions" | head -10
}

## Test

test_request(){
  local response
  response=$(curl http://localhost:${PORT}/)
  set +x
  if [ "$response" != "hello!" ]; then 
    echo "Error: Response "$response" was unexpected"
    exit 1
  else 
    echo "$response"
  fi
}

test(){
  test_request
}


help(){
  set +x
  echo "Available commands:"
  compgen -A function | awk '{print " ",$0}'
}

"$@"
