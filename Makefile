SYNCTHING_TAG ?= v1.29.2
SYNCTHING_USER ?= syncthing
SYNCTHING_UI_PORT ?= 8384

.PHONY: build-syncthing-container
build-syncthing-container:
	docker build -f build/Dockerfile.build -t syncthing-qnap-builder:latest build/

.PHONY: out/syncthing
out/syncthing: build-syncthing-container
	docker run --rm -v ${CURDIR}/out:/out -e SYNCTHING_TAG=${SYNCTHING_TAG} syncthing-qnap-builder

.PHONY: build-qdk-container
build-qdk-container:
	docker build -f build/Dockerfile.qpkg -t qdk:latest build/

.PHONY: out/pkg
out/pkg: build-qdk-container out/syncthing
	docker run --rm -v ${CURDIR}/out:/out -v ${CURDIR}/data:/data -e SYNCTHING_TAG=${SYNCTHING_TAG} -e SYNCTHING_USER=${SYNCTHING_USER} -e SYNCTHING_UI_PORT=${SYNCTHING_UI_PORT} qdk:latest

.PHONY: clean
clean:
	rm -rf out/pkg
	rm -f out/syncthing-*
