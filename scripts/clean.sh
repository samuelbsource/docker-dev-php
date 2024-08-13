#!/usr/bin/env bash

source ./scripts/_config.sh

for php in "${PHP_VERSIONS[@]}"; do
    for ubuntu in "${UBUNTU_VERSIONS[@]}"; do
        echo " ==> deleting ${REPOSITORY}:${php}-${ubuntu}"
        docker image rm "${REPOSITORY}:${php}-${ubuntu}"
    done
done
