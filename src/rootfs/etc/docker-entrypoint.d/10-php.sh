#!/usr/bin/env bash

source /usr/local/lib/shell/boolean.sh
source /usr/local/lib/shell/expand-from-env.sh
source /usr/local/lib/shell/php-ext.sh

# If the /etc/php/* directory is detected to be empty, default config will be copied there (useful when mounting directories)
if is_true "$PHP_COPY_CONFIG_ON_START"; then
    if [ ! -d "/etc/php/$PHP_VERSION" ] || [ -z "$(ls -A /etc/php/$PHP_VERSION)" ]; then
        echo "[docker-entrypoint.d/10-php.sh] Copying php config to /etc/php/$PHP_VERSION ... "

        mkdir --verbose --parents /etc/php/$PHP_VERSION/cli/conf.d /etc/php/$PHP_VERSION/fpm/conf.d /etc/php/$PHP_VERSION/fpm/pool.d
        chown --recursive "$USERNAME:$GROUPNAME" /etc/php/$PHP_VERSION/

        # Copy php.ini and other files
        install --verbose --owner="$USERNAME" --group="$GROUPNAME" --mode=644 "/usr/share/php/$PHP_VERSION/conf/cli/php.ini.env" "/etc/php/$PHP_VERSION/cli/php.ini.env"
        install --verbose --owner="$USERNAME" --group="$GROUPNAME" --mode=644 "/usr/share/php/$PHP_VERSION/conf/fpm/php.ini.env" "/etc/php/$PHP_VERSION/fpm/php.ini.env"
        install --verbose --owner="$USERNAME" --group="$GROUPNAME" --mode=644 "/usr/share/php/$PHP_VERSION/conf/fpm/php-fpm.conf" "/etc/php/$PHP_VERSION/fpm/php-fpm.conf"
        install --verbose --owner="$USERNAME" --group="$GROUPNAME" --mode=644 "/usr/share/php/$PHP_VERSION/conf/fpm/pool.d/www.conf.env" "/etc/php/$PHP_VERSION/fpm/pool.d/www.conf.env"
    fi
fi

# Enable PHP extensions
for sapi in {cli,fpm}; do
    enable_php_extensions "$sapi"
done

# Configure PHP with values from the environment
if is_true "$PHP_CONFIGURE_FROM_ENV"; then
    echo "[docker-entrypoint.d/10-php.sh] Configuring php from .env files ... "

    for filename in $(find "/etc/php/$PHP_VERSION/" -type f \( -name "*.ini.env" -or -name "*.conf.env" \)); do
        echo "[docker-entrypoint.d/10-php.sh] Substituting ENV variables in $filename"
        expand_from_env "$filename"
    done
fi

# fix file permissions
chown -R "$USERNAME:$GROUPNAME" /etc/php/$PHP_VERSION
