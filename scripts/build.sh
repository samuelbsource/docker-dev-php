#!/usr/bin/env bash

source ./scripts/_config.sh

packer init ./src
packer build -var "repository=$REPOSITORY" -var "source_repository=$SOURCE_REPOSITORY" ./src
