# docker-dev-php

[WIP] Docker php development images (based on [Ubuntu](https://github.com/samuelbsource/docker-dev-ubuntu))

## Project structure

- /scripts/* - Various scripts used to build and test images.
- /src/*.pkr.hcl - Packer build instructions, some of these files might be generated from a template.
- /src/scripts/*.sh - Image build scripts, these are run inside the build container to create the image, used will install packages and set file permissions.
- /src/rootfs/ - Image files, these will be added to the image, includes various bootstrap scripts, process configuration, utilities, etc...
- /test/ - created by the /scripts/test.sh script, various mutable directories are mounted here to test scenarios.

## Features

 - Advanced container bootstrapping (setup timezone, user id, configure processes)
 - Automatically reload application when configuration has changed (no need to restart container)
 - Supports environment values inside configuration values

## Environment substitution inside configuration files
My containers support custom configuration values with environment variable substitution. Just rename the config file to include .env suffix, and substitute values inside the config with {{ENV_VARIABLE_NAME}} - where VARIABLE_NAME can be anything you want. Scripts inside the container will automatically find and substitute these values with a value from the environment variable. For example, to make PHP memory limit be read from the environment, you can set  `memory_limit = {{ENV_PHP_MEMORY_LIMIT}}` in your php.ini.env file and when you start the container with `-e "PHP_MEMORY_LIMIT=2048M"` the value in your php.ini will be `memory_limit = 2024M`.

Additionally, containers support autoreloading of the configuration files as well as autoexpansion. This means that all you need to do is edit the file with the new value and supervisor will automatically generate new config and reload the application for you, in many cases without downtime (the existing process is not stopped, instead it's just sent a signal to load the new config file).

## About .env files

You can create .env file and mount it inside your container like the following `--volume="$(pwd)/.env:/.env:ro"` - The container will load all values defined in this file before running anything else, which means you can specify your environment values in a single file and share it with all your containers in a single project, this makes managing environment values less monotonous, keeps configuration in a single place and reduces duplication. Additonally, containers support auto-reloading of .env files, so you can edit a value inside and it will be applied immediately without having to restart your container.

## Why supervisor?

What is "one thing" really?
The answer will depend your personal opinion.
In context of containers used for development purposes, I understand "one thing" to be the packaged application and a set of tools required to effectively manage this application. Hence, in some cases I might want to run multiple processes inside a single container along side the main app. It's possible to run all of these outside the container, or in some cases in separate containers, but I found existing solutions to be lacking in many ways, either the setup is too complicated for the value provided, or the solution is less secure than if it were to run inside a single container. I also find it mentally easier to reason about containers as "packages" with all required tooling inside. I've been using similar setups for a while now and found them to be working very well for me.
