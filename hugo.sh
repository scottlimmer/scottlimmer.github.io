#!/usr/bin/env bash

HUGO_SERVER_PORT=1313
HUGO_DOCKER_IMAGE=hugomods/hugo:exts
SITE_ROOT="$(pwd)/docs"


docker_run() {
  docker run -v "$SITE_ROOT":/src --rm -p $HUGO_SERVER_PORT:1313 "$HUGO_DOCKER_IMAGE" "$@"
}

case "$1" in
  npm)
    docker_run "$@"
    ;;
  serve)
    shift
    docker_run hugo --environment local server --bind 0.0.0.0 "$@"
    ;;
  publish)
    shift
    docker_run hugo --environment local "$@"
    ;;
  *)
    docker_run hugo --environment local  "$@"
    ;;
esac
