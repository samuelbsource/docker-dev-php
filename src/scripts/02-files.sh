#!/usr/bin/env bash
set -e

alias install="install --verbose --owner=root --group=root"

# Copy files into right locations and set right permissions
install --mode=700 /tmp/rootfs/etc/docker-entrypoint.d/10-php.sh /etc/docker-entrypoint.d/10-php.sh
install --mode=700 /tmp/rootfs/etc/docker-env.d/10-php.sh /etc/docker-env.d/10-php.sh
install --mode=700 /tmp/rootfs/etc/docker-reloadpoint.d/10-php.sh /etc/docker-reloadpoint.d/10-php.sh
install --mode=700 /tmp/rootfs/etc/notify-files.d/10-php.sh /etc/notify-files.d/10-php.sh
install --mode=700 /tmp/rootfs/etc/notify.d/10-php.sh /etc/notify.d/10-php.sh
install --mode=600 /tmp/rootfs/etc/supervisor/conf.d/php.conf /etc/supervisor/conf.d/php.conf
install --mode=755 /tmp/rootfs/usr/local/lib/shell/php-ext.sh /usr/local/lib/shell/php-ext.sh
