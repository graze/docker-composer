#!/usr/bin/env bats

@test "alpine version is correct" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:php-7.0 -c 'cat /etc/os-release'
  echo 'status:' $status
  echo 'output:' $output
  [ $status -eq 0 ]
  [[ "${lines[2]}" == 'VERSION_ID=3.3.0' ]]
}

@test "composer version is correct" {
  run docker run --rm graze/composer:php-7.0 --version --no-ansi
  echo 'status:' $status
  echo 'output:' $output
  version="$(echo $output | awk '{ print $3 }')"
  echo 'version:' $version
  [ "$status" -eq 0 ]
  [ "$version" = "1.0-dev" ]
}

@test "the image entrypoint should be the composer wrapper" {
  run bash -c "docker inspect graze/composer:php-7.0 | jq -r '.[]?.Config.Entrypoint[]?'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/bin/composer-wrapper" ]
}

@test "the image has git installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:php-7.0 -c '[ -x /usr/bin/git ]'
  echo 'status:' $status
  [ "$status" -eq 0 ]
}

@test "the image has mercurial installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:php-7.0 -c '[ -x /usr/bin/hg ]'
  echo 'status:' $status
  [ "$status" -eq 0 ]
}

@test "the image has svn installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:php-7.0 -c '[ -x /usr/bin/svn ]'
  echo 'status:' $status
  [ "$status" -eq 0 ]
}

@test "the image has the php openssl module installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:php-7.0 -c '/usr/bin/php7 -m | grep -i openssl'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
}

@test "the image has the php curl module installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:php-7.0 -c '/usr/bin/php7 -m | grep -i curl'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
}

@test "the image has the php phar module installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:php-7.0 -c '/usr/bin/php7 -m | grep -i phar'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
}

@test "the image has the php json module installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:php-7.0 -c '/usr/bin/php7 -m | grep -i json'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
}

@test "the image has the php posix module installed" {
  run docker run --rm --entrypoint=/bin/sh graze/composer:php-7.0 -c '/usr/bin/php7 -m | grep -i posix'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
}
