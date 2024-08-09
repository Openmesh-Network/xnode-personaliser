#! /usr/bin/env bash

grep -oE 'XNODE_PERSONALISER_SCRIPT=([a-zA-Z0-0+=/]*)' /proc/cmdline | cut -d= -f2- | base64 -d > "${1}/xnode-personaliser-script.sh"
chmod +x "${1}/xnode-personaliser-script.sh"
exec "${1}/xnode-personaliser-script.sh"

exit 0
