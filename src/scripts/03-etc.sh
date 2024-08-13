#!/usr/bin/env bash
set -e

# Copy /etc/php/8.1/ -> /usr/share/php/8.1/conf
mkdir --verbose --parents /usr/share/php/$PHP_VERSION/conf
mkdir --verbose --parents /usr/share/php/$PHP_VERSION/conf/cli
mkdir --verbose --parents /usr/share/php/$PHP_VERSION/conf/fpm/pool.d
cp --verbose "/etc/php/$PHP_VERSION/cli/php.ini" "/usr/share/php/$PHP_VERSION/conf/cli/php.ini.env"
cp --verbose "/etc/php/$PHP_VERSION/fpm/php.ini" "/usr/share/php/$PHP_VERSION/conf/fpm/php.ini.env"
cp --verbose "/etc/php/$PHP_VERSION/fpm/php-fpm.conf" "/usr/share/php/$PHP_VERSION/conf/fpm/php-fpm.conf"
cp --verbose "/etc/php/$PHP_VERSION/fpm/pool.d/www.conf" "/usr/share/php/$PHP_VERSION/conf/fpm/pool.d/www.conf.env"

# delete /etc/php/8.1/
rm -rf /etc/php/$PHP_VERSION/

# override some default values
sed -i """
s|^pid *=.*$|pid = /var/run/php-fpm.pid|;
s|^error_log *=.*$|error_log = /proc/self/fd/2|;
s|^;*systemd_interval *=.*$|systemd_interval = 0|
""" "/usr/share/php/$PHP_VERSION/conf/fpm/php-fpm.conf"

sed -i """
s|^user *=.*$|user = {{ENV_USERNAME}}|;
s|^group *=.*$|group = {{ENV_GROUPNAME}}|;
s|^listen *=.*$|listen = 9000|;
s|^listen.owner|;listen.owner|;
s|^listen.group|;listen.group|
""" "/usr/share/php/$PHP_VERSION/conf/fpm/pool.d/www.conf.env"

sed -i """
s|^;*memory_limit *=.*$|memory_limit = {{ENV_PHP_CLI_MEMORY_LIMIT}}|
""" "/usr/share/php/$PHP_VERSION/conf/cli/php.ini.env"

sed -i """
s|^;*memory_limit *=.*$|memory_limit = {{ENV_PHP_FPM_MEMORY_LIMIT}}|
""" "/usr/share/php/$PHP_VERSION/conf/fpm/php.ini.env"
