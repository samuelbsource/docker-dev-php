#!/usr/bin/env bash

if [[ "${LINE[0]}" != "/.env" ]] && [[ "${LINE[0]}" == *".env" ]]; then
    # Expand changed .env files
    echo "[notify.d/10-php.sh] $(date '+%Y-%m-%d %H:%M:%S') A \"${LINE[1]}\" to \"${LINE[0]}\" was detected, regenerating file ... "
    expand_from_env "${LINE[0]}"

    # fix file permissions
    chown -R "$USERNAME:$GROUPNAME" /etc/php/$PHP_VERSION

    # Reload php-fpm if conf changed
    if [ -f "/var/run/php-fpm.pid" ] && ps --pid $(cat /var/run/php-fpm.pid) > /dev/null; then
        echo "[notify.d/10-php.sh] $(date '+%Y-%m-%d %H:%M:%S') Reloading php-fpm ... "
        $(which kill) --signal="USR2" $(cat /var/run/php-fpm.pid) # SIGUSR2 reloads conf and restarts all child workers
    fi
fi
