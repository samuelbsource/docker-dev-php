#!/usr/bin/env bash

source ./scripts/_config.sh

PHP_VERSION="$1"
UBUNTU_VERSION="$2"
CMD="$3" # Empty for default command or /bin/bash

if ! [[ "${PHP_VERSIONS[*]}" =~ "$PHP_VERSION" ]] || [[ -z "$PHP_VERSION" ]]; then
    echo "Unsupported PHP version: \"$PHP_VERSION\""
    exit 1
fi

if ! [[ "${UBUNTU_VERSIONS[*]}" =~ "$UBUNTU_VERSION" ]] || [[ -z "$UBUNTU_VERSION" ]]; then
    echo "Unsupported Ubuntu version: \"$UBUNTU_VERSION\""
    exit 1
fi

# Generate list of files to mount into the containers so that changes can be tested without rebuilding each time
VOLUMES=""
for item in $(find $(pwd)/src/rootfs -type f); do
    VOLUMES="${VOLUMES} --volume=${item}:${item##$(pwd)/src/rootfs}"
done

# Create test directory
if [ ! -d "$(pwd)/test" ]; then
    mkdir -pv "$(pwd)/test/php"
    touch "$(pwd)/test/.env"
    echo "touch: created file '$(pwd)/test/.env'"
    printf "%s\n%s\n" '# Set PHP memory limit' 'PHP_MEMORY_LIMIT = "2048M"' > "$(pwd)/test/.env"
fi

# Run docker
if [[ -z "$CMD" ]]; then
    docker run \
        --tty \
        --interactive \
        --rm \
        --name "php-${PHP_VERSION/./-}-${UBUNTU_VERSION/./-}" \
        --env "EXTENDED_DEBUG_INFORMATION=true" \
        --publish=9000:9000 \
        --publish=9003:9003 \
        --volume="$(pwd)/test/.env:/.env" \
        --volume="$(pwd)/test/php:/etc/php" \
        $VOLUMES \
            "${REPOSITORY}:${PHP_VERSION}-${UBUNTU_VERSION}"
else
    docker run \
        --tty \
        --interactive \
        --rm \
        --name "php-${PHP_VERSION/./-}-${UBUNTU_VERSION/./-}" \
        --env "EXTENDED_DEBUG_INFORMATION=true" \
        --publish=9000:9000 \
        --publish=9003:9003 \
        --volume="$(pwd)/test/.env:/.env" \
        --volume="$(pwd)/test/php:/etc/php" \
        $VOLUMES \
            "${REPOSITORY}:${PHP_VERSION}-${UBUNTU_VERSION}" "$CMD"
fi
