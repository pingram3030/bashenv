#!/usr/bin/env bash

for private_file in $(find "${ENV_ROOT}/profile.d/private/" -type f -name '*.sh'); do
    source ${private_file}
done

