#!/usr/bin/env bash
set -e

export LC_ALL="C.UTF-8"
export DEBIAN_FRONTEND="noninteractive"

# add ondrej php to the apt list
add-apt-repository --yes --no-update ppa:ondrej/php

# update and install packages
apt-get update
apt-get install -y "php${PHP_VERSION}" "php${PHP_VERSION}-fpm"

# link php-fpm8.1 to non version binary
ln -s /usr/sbin/php-fpm$PHP_VERSION /usr/sbin/php-fpm

# Fetch mhsendmail
case "$(uname --machine)" in
    x86_64)
        echo " ==> Fetching x86_64 version of mhsendmail"
        curl -L https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 > /tmp/mhsendmail
        echo "be5acdc8ce3f380dcb9d02caed77c845affa9a447d0860961529b699dcd0c613 /tmp/mhsendmail" > /tmp/mhsendmail.sha256sum
        if ! sha256sum --check --strict /tmp/mhsendmail.sha256sum; then
            exit 1
        fi
        install --verbose --owner=root --group=root --mode=755 /tmp/mhsendmail /usr/bin/mhsendmail
    ;;
    i386|i686)
        echo " ==> Fetching i386 version of mhsendmail"
        curl -L https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_386 > /tmp/mhsendmail
        echo "7052887469713631699898d020c6f3181eb96af4e9efde050636dd1540b418f8 /tmp/mhsendmail" > /tmp/mhsendmail.sha256sum
        if ! sha256sum --check --strict /tmp/mhsendmail.sha256sum; then
            exit 1
        fi
        install --verbose --owner=root --group=root --mode=755 /tmp/mhsendmail /usr/bin/mhsendmail
    ;;
    *)
        echo " ==X Unknown processor type"
        exit 1
    ;;
esac
