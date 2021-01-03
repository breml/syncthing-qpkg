#!/usr/bin/env bash

export GO111MODULE=on
git clone https://github.com/syncthing/syncthing.git
cd ./syncthing
git checkout $SYNCTHING_TAG

for GOARCH in 386 amd64 arm64; do
    go run build.go -goos linux -goarch $GOARCH build
    mv ./syncthing /out/syncthing-$GOARCH
done

for GOARM in 5 7; do
    export GOARM
    go run build.go -goos linux -goarch arm build
    mv ./syncthing /out/syncthing-armv$GOARM
done
