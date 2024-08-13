#!/usr/bin/env bash

source /usr/local/lib/shell/boolean.sh
source /usr/local/lib/shell/expand-from-env.sh
source /usr/local/lib/shell/php-ext.sh

# Enable PHP extensions
for sapi in {cli,fpm}; do
    enable_php_extensions "$sapi"
done

# Configure PHP with values from the environment
if is_true "$PHP_CONFIGURE_FROM_ENV"; then
    echo "[docker-reloadpoint.d/10-php.sh] Configuring php from .env files ... "

    for filename in $(find "/etc/php/$PHP_VERSION/" -type f \( -name "*.ini.env" -or -name "*.conf.env" \)); do
        echo "[docker-reloadpoint.d/10-php.sh] Substituting ENV variables in $filename"
        expand_from_env "$filename"
    done
fi

# fix file permissions
chown -R "$USERNAME:$GROUPNAME" /etc/php/$PHP_VERSION
