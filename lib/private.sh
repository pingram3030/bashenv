#!/usr/bin/env bash

for private_file in $(find "${ENV_LIB}/private/" -type f -name '*.sh'); do
    source ${private_file}
done

