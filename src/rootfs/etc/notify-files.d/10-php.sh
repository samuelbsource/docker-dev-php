#!/usr/bin/env bash

# collect files to watch
find /etc/php/$PHP_VERSION/ -type f \( -name "*.ini" -or -name "*.conf" -or -name "*.ini.env" -or -name "*.conf.env" \)
