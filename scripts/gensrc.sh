#!/usr/bin/env bash

source ./scripts/_config.sh
source ./scripts/templates/sources.pkr.hcl.sh
source ./scripts/templates/builds.pkr.hcl.sh

# Manually scripting sources and builds for every possible combination of php and ubuntu can be a bit tedious
# so I've created this script to generate code for possible combinations instead.
# Just edit /scripts/_config.sh and run this command to generate additional php and ubuntu combinations.

echo " ==> Generating ./src/sources.pkr.hcl"
sources_hcl_template > ./src/sources.pkr.hcl

echo " ==> Generating ./src/builds.pkr.hcl"
builds_hcl_template > ./src/builds.pkr.hcl
