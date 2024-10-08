#!/usr/bin/env bash

function builds_source_hcl_template () {
    local v=""
    for php in "${PHP_VERSIONS[@]}"; do
        for ubuntu in "${UBUNTU_VERSIONS[@]}"; do
            v="$v    \"source.docker.php-${php/./-}-${ubuntu/./-}\",\n"
        done
    done
    echo -e "${v:0:-3}"
}

function builds_provisioner_shell_hcl_template () {
    local v=""
    for php in "${PHP_VERSIONS[@]}"; do
        v="""$v
  provisioner \"shell\" {
    scripts = fileset(abspath(path.cwd), trimprefix(\"\${trimprefix(abspath(path.root), abspath(path.cwd))}/scripts/*.sh\", \"/\"))
    env = {
      PHP_VERSION = \"${php}\"
    }
    only = ["""
        for ubuntu in "${UBUNTU_VERSIONS[@]}"; do
            v="${v}\"docker.php-${php/./-}-${ubuntu/./-}\", "
        done
        v="""${v:0:-2}]
  }"""
    done
    echo "$v"
}

function builds_postprocessor_hcl_template () {
    for php in "${PHP_VERSIONS[@]}"; do
        for ubuntu in "${UBUNTU_VERSIONS[@]}"; do
            cat <<EOS
  post-processor "docker-tag" {
    repository = var.repository
    tags = ["${php}-${ubuntu}"]
    only = ["docker.php-${php/./-}-${ubuntu/./-}"]
  }
EOS
        done
    done
}

function builds_hcl_template () {
    cat <<EOF
// Generated by ./scripts/gensrc.sh
build {
  sources = [
$(builds_source_hcl_template)
  ]

  provisioner "file" {
    source = trimprefix("\${trimprefix(abspath(path.root), abspath(path.cwd))}/rootfs", "/")
    destination = "/tmp/rootfs"
  }
$(builds_provisioner_shell_hcl_template)

$(builds_postprocessor_hcl_template)
}
EOF
}
