#!/bin/sh
# Based on https://github.com/BOINC/boinc-client-docker/blob/4e6dec4559fcecc67031edc4b1d626a22ac62e19/bin/start-boinc.sh

# Configure the BOINC GUI RPC
echo "${BOINC_GUI_RPC_PASSWORD}" > /var/lib/boinc/gui_rpc_auth.cfg
echo "${BOINC_REMOTE_HOST}" > /var/lib/boinc/remote_hosts.cfg

# Run BOINC by default, or the CMD passed as argument
# shellcheck disable=SC2086
if [ "$#" -gt 0 ]; then
    exec "$@"
else
    exec /usr/bin/boinc $BOINC_CMD_LINE_OPTIONS
fi
