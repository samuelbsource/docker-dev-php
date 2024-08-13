#!/usr/bin/env bash

function sources_hcl_template () {
    echo "// Generated by ./scripts/gensrc.sh"
    for php in "${PHP_VERSIONS[@]}"; do
        for ubuntu in "${UBUNTU_VERSIONS[@]}"; do
            cat <<EOS
source "docker" "php-${php/./-}-${ubuntu/./-}" {
  image = "\${var.source_repository}:${ubuntu}"
  commit = true
  changes = [
    "ENTRYPOINT [\\"\${local.image_entrypoint}\\"]",
    "CMD [\\"\${join("\\", \\"", local.image_default_command)}\\"]",
    "WORKDIR /",
    "LABEL org.opencontainers.image.title=\\"PHP ${php} (Ubuntu ${ubuntu})\\"",
    "LABEL org.opencontainers.image.description=\\"PHP image based on ubuntu.\\"",
    "LABEL org.opencontainers.image.base.name=\${var.repository}:${php}-${ubuntu}",
    "LABEL org.opencontainers.image.authors=\\"\${join(", ", local.authors)}\\"",
    "LABEL org.opencontainers.image.created=\${timestamp()}",
    "LABEL org.opencontainers.image.version=${php}-${ubuntu}",
    "LABEL org.opencontainers.image.source=\\"\${local.source}\\""
  ]
}
EOS
        done
    done
}
