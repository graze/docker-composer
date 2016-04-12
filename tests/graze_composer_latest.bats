#!/usr/bin/env bats

setup() {
  tag=$(basename $(echo $BATS_TEST_FILENAME | cut -d _ -f 3) .bats)
}

teardown() {
  rm -rf ./tests/.composer || true
  rm -rf ./tests/composer.lock || true
  rm -rf ./tests/vendor || true
}

@test "alpine version is correct" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c 'cat /etc/os-release'
  echo 'status:' $status
  echo 'output:' $output
  [ $status -eq 0 ]
  [[ "${lines[2]}" == 'VERSION_ID=3.3.0' ]]
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

@test "the image has php 7.0 installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c '/usr/bin/php7 --version'
  echo 'status:' $status
  echo 'output:' $output
  version="$(echo ${lines[0]} | awk '{ print $2 }')"
  echo 'version:' $version
  [ "$status" -eq 0 ]
  [[ "$version" == 7.0.* ]]
}

@test "the image has the correct php modules installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c '/usr/bin/php7 -m'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  # Lowercase the output before we match
  [[ "${output,,}" == *"curl"* ]]
  [[ "${output,,}" == *"json"* ]]
  [[ "${output,,}" == *"openssl"* ]]
  [[ "${output,,}" == *"phar"* ]]
  [[ "${output,,}" == *"posix"* ]]
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
  [[ "${lines[2]}" == "  - Installing psr/log (1.0.0)"* ]]
  [[ "${lines[3]}" == "    Downloading"* ]]
  [[ "${lines[5]}" == "Writing lock file"* ]]
  [[ "${lines[6]}" == "Generating autoload files"* ]]
}

@test "composer works as expected when installing packages with configuration volume mounts" {
  run docker run --rm -t -v "$(pwd)":/usr/src/app -v "$(pwd)/tests/.composer":/home/composer/.composer \
    graze/composer:"$tag" install --no-ansi --working-dir ./tests --no-interaction
  echo "status: $status"
  printf 'output: %s\n' "${lines[@]}" | cat -vt
  [[ "${lines[0]}" == "Loading composer repositories with package information"* ]]
  [[ "${lines[1]}" == "Updating dependencies (including require-dev)"* ]]
  [[ "${lines[2]}" == "  - Installing psr/log (1.0.0)"* ]]
  [[ "${lines[3]}" == "    Downloading"* ]]
  [[ "${lines[5]}" == "Writing lock file"* ]]
  [[ "${lines[6]}" == "Generating autoload files"* ]]
}
