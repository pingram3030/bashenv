#!/usr/bin/env bash

HOST_FILE="${ENV_LIB}/host/$(hostname -s).sh"

[[ -f ${HOST_FILE} ]] && source ${HOST_FILE}
