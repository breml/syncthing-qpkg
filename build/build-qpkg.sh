#!/bin/bash

export PATH=$PATH:/usr/share/QDK/bin
export VERSION=${SYNCTHING_TAG:-1}
export SYNCTHING_UI_PORT=${SYNCTHING_UI_PORT:-8384}
export SYNCTHING_USER=${SYNCTHING_USER:-syncthing}

qbuild --create-env Syncthing --build-version $VERSION

cp out/syncthing-386 /Syncthing/x86/syncthing
cp out/syncthing-386 /Syncthing/x86_ce53xx/syncthing
cp out/syncthing-amd64 /Syncthing/x86_64/syncthing

cp out/syncthing-armv7 /Syncthing/arm-x41/syncthing
cp out/syncthing-armv7 /Syncthing/arm-x31/syncthing
cp out/syncthing-armv5 /Syncthing/arm-x19/syncthing
cp out/syncthing-arm64 /Syncthing/arm_64/syncthing

cp /data/package_routines /Syncthing/package_routines

mkdir -p /Syncthing/shared/var/run/syncthing
mkdir -p /Syncthing/shared/var/lib/certs
mkdir -p /Syncthing/shared/var/lib/syncthing/config
mkdir -p /Syncthing/shared/var/lib/syncthing/data
mkdir -p /Syncthing/shared/var/log

cp /data/certs/ca-certificates.crt /Syncthing/shared/var/lib/certs

sed -i '/QPKG_AUTHOR/cQPKG_AUTHOR="Lucas Bremgartner"' /Syncthing/qpkg.cfg

sed -i '/#QPKG_SERVICE_PORT/cQPKG_SERVICE_PORT="22000"' /Syncthing/qpkg.cfg

sed -i "/#QPKG_WEB_PORT/cQPKG_WEB_PORT=\"$SYNCTHING_UI_PORT\"" /Syncthing/qpkg.cfg
sed -i '/#QPKG_USE_PROXY/cQPKG_USE_PROXY="0"' /Syncthing/qpkg.cfg

sed -i '/QTS_MINI_VERSION/cQTS_MINI_VERSION="4.0.2"' /Syncthing/qpkg.cfg

# SYNCTHING_USER and SYNCTHING_UI_PORT are placeholders and are replaced later
sed -i '/: ADD START ACTIONS HERE/c\
    CMD_SUDO="/usr/bin/sudo"
    [ ! -x $CMD_SUDO ] && CMD_SUDO="/opt/bin/sudo"
    [ ! -x $CMD_SUDO ] && exit 1
    $CMD_SUDO STNODEFAULTFOLDER=1 SSL_CERT_FILE=$QPKG_ROOT/var/lib/certs/ca-certificates.crt -u SYNCTHING_USER $QPKG_ROOT/syncthing -gui-address="http://0.0.0.0:SYNCTHING_UI_PORT" -no-browser -config=$QPKG_ROOT/var/lib/syncthing/config -data=$QPKG_ROOT/var/lib/syncthing/data -logfile=$QPKG_ROOT/var/log/syncthing.log &\
    echo $! > $QPKG_ROOT/var/run/syncthing/syncthing.pid\
    sleep 3' /Syncthing/shared/Syncthing.sh

sed -i "s/SYNCTHING_UI_PORT/$SYNCTHING_UI_PORT/g" /Syncthing/shared/Syncthing.sh
sed -i "s/SYNCTHING_USER/$SYNCTHING_USER/g" /Syncthing/shared/Syncthing.sh
sed -i "s/SYNCTHING_USER/$SYNCTHING_USER/g" /Syncthing/package_routines

sed -i '/: ADD STOP ACTIONS HERE/c\
    ID=$(more $QPKG_ROOT/var/run/syncthing/syncthing.pid)\
    if [ -e $QPKG_ROOT/var/run/syncthing/syncthing.pid ]; then\
        kill $ID\
        rm -f $QPKG_ROOT/var/run/syncthing/syncthing.pid\
    fi' /Syncthing/shared/Syncthing.sh

qbuild --root /Syncthing --build-arch x86 --build-dir /out/pkg
qbuild --root /Syncthing --build-arch x86_ce53xx --build-dir /out/pkg
qbuild --root /Syncthing --build-arch x86_64 --build-dir /out/pkg
qbuild --root /Syncthing --build-arch arm-x19 --build-dir /out/pkg
qbuild --root /Syncthing --build-arch arm-x31 --build-dir /out/pkg
qbuild --root /Syncthing --build-arch arm-x41 --build-dir /out/pkg
qbuild --root /Syncthing --build-arch arm_64 --build-dir /out/pkg

chmod -R 777 /out
