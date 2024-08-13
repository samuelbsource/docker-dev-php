#!/usr/bin/env bash

# A list of environment variables used by the container.
# Some of these variables are derived from other environment variables,
# hance I needed a separate script that I can re-run many time withthin the container.
# An added benefit of this file is that it's a one-stop place to list environment variables available for configuration.

export PHP_VERSION=$(/usr/bin/php -n -r "echo explode('.', phpversion())[0] . '.' . explode('.', phpversion())[1];")  # Set to the installed PHP_VERSION, e.g. 8.1
export PHP_EXT_DIR=$(/usr/bin/php -n -i | grep "extension_dir => " | awk -F\ =\>\  '{print $2}')                      # Set to the patch where extensions are installed

# Variables used by docker-entrypoint & php-inotify.sh
export PHP_COPY_CONFIG_ON_START=${PHP_COPY_CONFIG_ON_START:-true}         # When enabled and /etc/php/$PHP_VERSION directory is empty, initial configuration files will be copied to this directory when bootstrapping the container.
export PHP_CONFIGURE_FROM_ENV=${PHP_CONFIGURE_FROM_ENV:-true}             # When enabled, *.env files will be used to generate configuration files with values from the environment.

# Default variables available for PHP configuration
export PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT:-"512M"}                       # Default memory limit for CLI and FPM
export PHP_CLI_MEMORY_LIMIT=${PHP_CLI_MEMORY_LIMIT:-"$PHP_MEMORY_LIMIT"}  # Default memory limit for CLI
export PHP_FPM_MEMORY_LIMIT=${PHP_FPM_MEMORY_LIMIT:-"$PHP_MEMORY_LIMIT"}  # Default memory limit for FPM

export PHP_SENDMAIL_PATH=${PHP_SENDMAIL_PATH:-"/usr/bin/mhsendmail --smtp-addr='localhost:1025'"}  # mhsendmail can be used to send all emails to the specified testing SMTP server 
export PHP_CLI_SENDMAIL_PATH=${PHP_CLI_SENDMAIL_PATH:-"$PHP_SENDMAIL_PATH"}                        # Sendmail for CLI
export PHP_FPM_SENDMAIL_PATH=${PHP_FPM_SENDMAIL_PATH:-"$PHP_SENDMAIL_PATH"}                        # Sendmail for FPM

# PHP-FPM pool configuration
export PHP_FPM_USERNAME=${PHP_FPM_USERNAME:-"$USERNAME"}    # PHP-FPM www pool will run as this user.
export PHP_FPM_GROUPNAME=${PHP_FPM_GROUPNAME:-"$GROUPNAME"} # PHP-FPM www pool will run as this group.
export PHP_FPM_LISTEN=${PHP_FPM_LISTEN:-"9000"}             # PHP-FPM www pool will listen on this address/port/socket

# Enable the following PHP extensions
export PHP_EXTENSIONS=${PHP_EXTENSIONS:-"calendar ctype exif ffi fileinfo ftp gettext iconv pdo phar posix readline shmop sockets sysvmsg sysvsem sysvshm tokenizer opcache"}
export PHP_CLI_EXTENSIONS=${PHP_CLI_EXTENSIONS:-"$PHP_EXTENSIONS"}  # Enable extensions for CLI only
export PHP_FPM_EXTENSIONS=${PHP_FPM_EXTENSIONS:-"$PHP_EXTENSIONS"}  # Enable extensions for FPM only
