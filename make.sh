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
  docker build $args -f "Dockerfile.$tag" -t ${SCOPE_NAME}:$tag .
}

docker_build_proxy(){
  local dockerfile=${1:-Dockerfile}
  args=""
  [ -z $DOCKER_BUILD_PROXY ] || args="$args --build-arg DOCKER_BUILD_PROXY=${DOCKER_BUILD_PROXY}"
  docker build $args -f "$dockerfile" .
}

### Commands

build(){
  build_plain
  build_forever
  build_s6
  build_supervisor
}

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

run_image(){
  local tag=${1:-plain}
  docker run -p "${PORT}:8080" "${SCOPE_NAME}:${tag}"
}

run(){
  run_image "$@"
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

