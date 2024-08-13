locals {
  image_entrypoint = "/docker-entrypoint.sh"
  image_default_command = ["/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisor/supervisord.conf"]
  authors = [
    "Samuel Boczek <samuelboczek@gmail.com>"
  ]
  source = "https://github.com/samuelbsource/docker-dev-php"
}
