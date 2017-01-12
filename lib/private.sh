#!/usr/bin/env bash
#
# Load all private libraries. The private folder herein is .gitignored
#
for private_file in $(find "${ENV_LIB}/private/" -type f -name '*.sh'); do
    source ${private_file}
done

