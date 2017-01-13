#!/usr/bin/env bash
#
# Enable per host configurations
#

HOST_FILE="${ENV_LIB}/host/$(hostname -s).sh"

[[ -f ${HOST_FILE} ]] && source ${HOST_FILE}
