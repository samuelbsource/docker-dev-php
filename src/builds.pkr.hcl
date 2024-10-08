// Generated by ./scripts/gensrc.sh
build {
  sources = [
    "source.docker.php-8-1-20-04",
    "source.docker.php-8-1-22-04",
    "source.docker.php-8-2-20-04",
    "source.docker.php-8-2-22-04",
    "source.docker.php-8-3-20-04",
    "source.docker.php-8-3-22-04"
  ]

  provisioner "file" {
    source = trimprefix("${trimprefix(abspath(path.root), abspath(path.cwd))}/rootfs", "/")
    destination = "/tmp/rootfs"
  }

  provisioner "shell" {
    scripts = fileset(abspath(path.cwd), trimprefix("${trimprefix(abspath(path.root), abspath(path.cwd))}/scripts/*.sh", "/"))
    env = {
      PHP_VERSION = "8.1"
    }
    only = ["docker.php-8-1-20-04", "docker.php-8-1-22-04"]
  }
  provisioner "shell" {
    scripts = fileset(abspath(path.cwd), trimprefix("${trimprefix(abspath(path.root), abspath(path.cwd))}/scripts/*.sh", "/"))
    env = {
      PHP_VERSION = "8.2"
    }
    only = ["docker.php-8-2-20-04", "docker.php-8-2-22-04"]
  }
  provisioner "shell" {
    scripts = fileset(abspath(path.cwd), trimprefix("${trimprefix(abspath(path.root), abspath(path.cwd))}/scripts/*.sh", "/"))
    env = {
      PHP_VERSION = "8.3"
    }
    only = ["docker.php-8-3-20-04", "docker.php-8-3-22-04"]
  }

  post-processor "docker-tag" {
    repository = var.repository
    tags = ["8.1-20.04"]
    only = ["docker.php-8-1-20-04"]
  }
  post-processor "docker-tag" {
    repository = var.repository
    tags = ["8.1-22.04"]
    only = ["docker.php-8-1-22-04"]
  }
  post-processor "docker-tag" {
    repository = var.repository
    tags = ["8.2-20.04"]
    only = ["docker.php-8-2-20-04"]
  }
  post-processor "docker-tag" {
    repository = var.repository
    tags = ["8.2-22.04"]
    only = ["docker.php-8-2-22-04"]
  }
  post-processor "docker-tag" {
    repository = var.repository
    tags = ["8.3-20.04"]
    only = ["docker.php-8-3-20-04"]
  }
  post-processor "docker-tag" {
    repository = var.repository
    tags = ["8.3-22.04"]
    only = ["docker.php-8-3-22-04"]
  }
}
