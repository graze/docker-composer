#!/usr/bin/env bats

setup() {
  tag=$(basename "$(echo $BATS_TEST_FILENAME | cut -d _ -f 3)" .bats)
}

teardown() {
  ls -lR ./tests/*
  rm -rf ./tests/.composer
  rm -rf ./tests/composer.lock
  rm -rf ./tests/vendor
}

@test "alpine version is correct" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c 'cat /etc/os-release'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${lines[2]}" == "VERSION_ID=3.5."* ]]
}

@test "composer version is correct" {
  run docker run --rm graze/composer:$tag --version --no-ansi
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == "Composer version 1."* ]]
  [[ "$output" != *"-dev"* ]]
  [[ "$output" != *"-alpha"* ]]
  [[ "$output" != *"-beta"* ]]
}

@test "the image has a disk size under 100MB" {
    run docker images graze/composer:$tag
    echo 'status:' $status
    echo 'output:' $output
    size="$(echo ${lines[1]} | awk -F '   *' '{ print int($5) }')"
    echo 'size:' $size
    [ "$status" -eq 0 ]
    [ $size -lt 100 ]
}

@test "the image has a MIT license" {
  run bash -c "docker inspect graze/composer:$tag | jq -r '.[].Config.Labels.license'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "MIT" ]
}

@test "the image has a maintainer" {
  run bash -c "docker inspect graze/composer:$tag | jq -r '.[].Config.Labels.maintainer'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "developers@graze.com" ]
}

@test "the image uses label-schema.org" {
  run bash -c "docker inspect graze/composer:$tag | jq -r '.[].Config.Labels.\"org.label-schema.schema-version\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "1.0" ]
}

@test "the image has a vcs-url label" {
  run bash -c "docker inspect graze/composer:$tag | jq -r '.[].Config.Labels.\"org.label-schema.vcs-url\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "https://github.com/graze/docker-composer" ]
}

@test "the image has a vcs-ref label set to the current head commit in github" {
  run bash -c "docker inspect graze/composer:$tag | jq -r '.[].Config.Labels.\"org.label-schema.vcs-ref\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = `git rev-parse --short HEAD` ]
}

@test "the image has a build-date label" {
  run bash -c "docker inspect graze/composer:$tag | jq -r '.[].Config.Labels.\"org.label-schema.build-date\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" != "null" ]
}

@test "the image has a vendor label" {
  run bash -c "docker inspect graze/composer:$tag | jq -r '.[].Config.Labels.\"org.label-schema.vendor\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "graze" ]
}

@test "the image has a name label" {
  run bash -c "docker inspect graze/composer:$tag | jq -r '.[].Config.Labels.\"org.label-schema.name\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "composer" ]
}

@test "the composer wrapper has been copied" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c '[ -x /usr/local/bin/composer-wrapper ]'
  echo 'status:' $status
  [ "$status" -eq 0 ]
}

@test "the image entrypoint should be the composer wrapper" {
  run bash -c "docker inspect graze/composer:$tag | jq -r '.[].Config.Entrypoint[]'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/bin/composer-wrapper" ]
}

@test "the image has git installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c '[ -x /usr/bin/git ]'
  echo 'status:' $status
  [ "$status" -eq 0 ]
}

@test "the image has openssh installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c '[ -x /usr/bin/ssh ]'
  echo 'status:' $status
  [ "$status" -eq 0 ]
}

@test "the image has mercurial installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c '[ -x /usr/bin/hg ]'
  echo 'status:' $status
  [ "$status" -eq 0 ]
}

@test "the image has svn installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c '[ -x /usr/bin/svn ]'
  echo 'status:' $status
  [ "$status" -eq 0 ]
}

@test "the image has php 5.6 installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c '/usr/bin/php --version'
  echo 'status:' $status
  echo 'output:' $output
  version="$(echo ${lines[0]} | awk '{ print $2 }')"
  echo 'version:' $version
  [ "$status" -eq 0 ]
  [[ "$version" == 5.6.* ]]
}

@test "the image has the correct php modules installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c '/usr/bin/php -m'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${output}" == *"ctype"* ]]
  [[ "${output}" == *"curl"* ]]
  [[ "${output}" == *"json"* ]]
  [[ "${output}" == *"openssl"* ]]
  [[ "${output}" == *"Phar"* ]]
  [[ "${output}" == *"posix"* ]]
  [[ "${output}" == *"zlib"* ]]
}

@test "the image has the composer environment variables set" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c '/usr/bin/env'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${output}" == *"COMPOSER_ALLOW_SUPERUSER=1"* ]]
  [[ "${output}" == *"COMPOSER_HOME=/home/composer/.composer"* ]]
}

@test "the root user warning isn't displayed by composer" {
  run docker run --rm -t graze/composer:$tag --version --no-ansi
  echo 'status:' $status
  echo 'output:' $output
  [[ "$output" != *"Running composer as root is highly discouraged"* ]]
}

@test "composer works as expected when installing packages" {
  run docker run --rm -t -v "$(pwd)":/usr/src/app \
    graze/composer:"$tag" install --no-ansi --working-dir ./tests --no-interaction
  echo "status: $status"
  printf 'output: %s\n' "${lines[@]}" | cat -vt
  [[ "${lines[0]}" == "Loading composer repositories with package information"* ]]
  [[ "${lines[1]}" == "Updating dependencies (including require-dev)"* ]]
  [[ "${lines[2]}" == "Package operations: 1 install, 0 updates, 0 removals"* ]]
  [[ "${lines[3]}" == "  - Installing psr/log (1.0.2): Downloading"* ]]
  [[ "${lines[4]}" == "Writing lock file"* ]]
  [[ "${lines[5]}" == "Generating autoload files"* ]]
}

@test "composer works as expected when installing packages with configuration volume mounts" {
  mkdir -p ./tests/.composer
  run docker run --rm -t -v "$(pwd)":/usr/src/app \
    -v "$(pwd)/tests/.composer":/home/composer/.composer \
    graze/composer:"$tag" install --no-ansi --working-dir ./tests --no-interaction
  echo "status: $status"
  printf 'output: %s\n' "${lines[@]}" | cat -vt
  [[ "${lines[0]}" == "Loading composer repositories with package information"* ]]
  [[ "${lines[1]}" == "Updating dependencies (including require-dev)"* ]]
  [[ "${lines[2]}" == "Package operations: 1 install, 0 updates, 0 removals"* ]]
  [[ "${lines[3]}" == "  - Installing psr/log (1.0.2): Downloading"* ]]
  [[ "${lines[4]}" == "Writing lock file"* ]]
  [[ "${lines[5]}" == "Generating autoload files"* ]]
}
