#!/usr/bin/env bash

set -uex -o pipefail

ARGS="${@:-build}"
DOCKER_BUILD_PROXY=${DOCKER_BUILD_PROXY:-}

docker_build(){
  local tag=${1}
  args=""
  docker build $args -f "Dockerfile.$tag" -t dply/node-docker-demo-app:$tag .
}

docker_build_proxy(){
  local dockerfile=${1:-Dockerfile}
  args=""
  [ -z $DOCKER_BUILD_PROXY ] || args="$args --build-arg DOCKER_BUILD_PROXY=${DOCKER_BUILD_PROXY}"
  docker build $args -f "$dockerfile" .
}

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

"$ARGS"
