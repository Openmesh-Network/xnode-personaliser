#! /usr/bin/env bash

cat /proc/cmdline | grep -oE 'XNODE_PERSONALISER_SCRIPT=([a-zA-Z0-0+=/]*)' | cut -d= -f2- | base64 -d > xnode-personaliser-script.sh
chmod +x xnode-personaliser-script.sh
exec xnode-personaliser-script.sh

exit 0
