#!/usr/bin/env bash

source /usr/local/lib/shell/boolean.sh

function enable_php_extensions {
    local sapi="$(printf "%s" "$1" | awk '{print tolower($0)}')"
    local var_name="PHP_$(printf "%s" "$1" | awk '{print toupper($0)}')_EXTENSIONS"
    local extensions=(${!var_name})

    # Reset current file
    echo -n "" > /etc/php/$PHP_VERSION/$sapi/conf.d/00-extensions.ini

    for extension in "${extensions[@]}"; do
        case $(detect_extension "$extension"; echo "$?") in
            0)
                if is_true "$EXTENDED_DEBUG_INFORMATION"; then
                    echo "[php-ext.sh] Enabling $sapi php extension \"${extension}.so\""
                fi
                echo "extension=${extension}.so" >> /etc/php/$PHP_VERSION/$sapi/conf.d/00-extensions.ini
            ;;
            1)
                if is_true "$EXTENDED_DEBUG_INFORMATION"; then
                    echo "[php-ext.sh] Enabling $sapi zend extension \"${extension}.so\""
                fi
                echo "zend_extension=${extension}.so" >> /etc/php/$PHP_VERSION/$sapi/conf.d/00-extensions.ini
            ;;
            *)
                echo "[php-ext.sh] ERROR: cannot load the \"${extension}.so\" $sapi extension."
            ;;
        esac
    done

    # Print enabled extensions (including built-in)
    if is_true "$EXTENDED_DEBUG_INFORMATION"; then
        printf "%s\n" "[php-ext.sh] Enabled CLI modules:"
        php -n -c "/etc/php/$PHP_VERSION/cli/conf.d/00-extensions.ini" -m |\
            while read -r -a LINE; do
                if [[ "${LINE[@]}" == "["* ]]; then
                    echo "[php-ext.sh]  ${LINE[@]}"
                elif [[ -z "${LINE[@]}" ]]; then
                    echo "[php-ext.sh]"
                else
                    echo "[php-ext.sh]   - ${LINE[@]}"
                fi
            done

        printf "%s\n" "[php-ext.sh] Enabled FPM modules:"
        php -n -c "/etc/php/$PHP_VERSION/fpm/conf.d/00-extensions.ini" -m |\
            while read -r -a LINE; do
                if [[ "${LINE[@]}" == "["* ]]; then
                    echo "[php-ext.sh]  ${LINE[@]}"
                elif [[ -z "${LINE[@]}" ]]; then
                    echo "[php-ext.sh]"
                else
                    echo "[php-ext.sh]   - ${LINE[@]}"
                fi
            done
    fi
}

# Return 0 when php extension, 1 when zend extension, or 2 when does not exist or unknown.
function detect_extension {
    return $(
        php -n -dextension="$1" -r '' |& awk '{print tolower($0)}' |\
            while read -r -a LINE; do
                if [[ "${LINE[@]}" == *"appears to be a zend extension"* ]]; then
                    echo "1"
                elif [[ "${LINE[@]}" == *"unable to load dynamic library"* ]]; then
                    echo "2"
                elif [[ ! -z "${LINE[@]}" ]]; then
                    echo "0"
                fi
            done
    )
}
