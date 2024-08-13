#!/usr/bin/env bash

source ./scripts/_config.sh

for php in "${PHP_VERSIONS[@]}"; do
    for ubuntu in "${UBUNTU_VERSIONS[@]}"; do
        echo " ==> pushing ${REPOSITORY}:${php}-${ubuntu}"
        docker push "${REPOSITORY}:${php}-${ubuntu}"
    done
done
