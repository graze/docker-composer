#!/usr/bin/env bats

setup() {
  tag=$(basename $(echo $BATS_TEST_FILENAME | cut -d _ -f 3) .bats)
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
  run bash -c "docker inspect graze/composer:$tag | jq -r '.[]?.Config.Entrypoint[]?'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/bin/composer-wrapper" ]
}

@test "the image volumes are correct" {
  run bash -c "docker inspect graze/composer:$tag | jq -r '@sh \"\(.[]?.Config.Volumes | to_entries | map(.key))\"'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == *"/usr/src/app"* ]]
  [[ "$output" == *"/home/composer/.composer"* ]]
}

@test "the image has git installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:$tag -c '[ -x /usr/bin/git ]'
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
  run docker run --rm --entrypoint=/bin/sh graze/composer:latest -c '/usr/bin/php7 --version'
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

@test "the root user warning isn't displayed by composer" {
  run docker run --rm -t graze/composer:latest --version --no-ansi
  echo 'status:' $status
  echo 'output:' $output
  [[ "$output" != *"Running composer as root is highly discouraged"* ]]
}
