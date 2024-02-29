# Syncthing QPKG builder

This repository includes build scripts for building [Syncthing](https://github.com/syncthing/syncthing) QPKG for
use in QNAP NAS.

## Build

The build depends on Docker and `make`. All other build dependencies are
downloaded in the Docker containers. To invoke the build, run `make out/pkg`.
This builds Syncthing QPKG for different platforms and stores them in
`out/pkg`.

By default, the v1.27.3 Syncthing release is built. To configure the release
number, set the environment variable `SYNCTHING_TAG` to the release number, e.g.
`SYNCTHING_TAG=v1.27.3 make out/pkg`.

By default, syncthing uses the user `syncthing`, which needs to be created on
the QNAP manually before the installation of `syncthing`. To configure the user
used to store the sync-ed data, set the environment variable `SYNCTHING_USER`,
e.g. `SYNCTHING_USER=myuser make out/pkg`.

By default, syncthing uses the port `8384` for its UI. To configure the port,
set the environment variable `SYNCTHING_UI_PORT`,
e.g. `SYNCTHING_UI_PORT=8384 make out/pkg`.

Alternatively, the automatically built packages can be download from Github
Actions. Packages are built once a week.

## Installation

1. Create a user named `syncthing` (or whatever you have defined in `SYNCTHING_USER`) on the QNAP.
2. Manually install Syncthing package in QNAP App Center.
3. Access the Syncthing UI via the Syncthing entry in the QNAP menu or access it directly on `http://<ip of your QNAP>:8384/` (use the port defined in `SYNCTHING_UI_PORT`).
4. Set a username and password for the Syncthing UI.

## License

This repository is licensed under MIT.

## Thanks

This Syncthing QPKG builder is heavily based on the [Tailscale QPKG builder](https://github.com/ivokub/tailscale-qpkg) by Ivo Kubjas.
