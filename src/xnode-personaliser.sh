#! /usr/bin/env bash

SCRIPT_CONTENTS=$(grep -oE 'XNODE_PERSONALISER_SCRIPT=\S+' /proc/cmdline | cut -d= -f2-)

echo "Found contents: " $SCRIPT_CONTENTS

echo $SCRIPT_CONTENTS | base64 -d | gzip -d 2>/dev/null > "${1}/xnode-personaliser-script.sh"

echo "Running: " $(cat "${1}/xnode-personaliser-script.sh")

chmod +x "${1}/xnode-personaliser-script.sh"
exec "${1}/xnode-personaliser-script.sh"

echo "Ran script"

exit 0
