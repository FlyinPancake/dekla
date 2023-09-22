#!/bin/fish
docker run -p 8080:8080 -p 8081:8081 --pull always -v (readlink -f livebooks):/data -u (id -u):(id -g) ghcr.io/livebook-dev/livebook
