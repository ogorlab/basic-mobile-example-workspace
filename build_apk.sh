#!/usr/bin/env bash

set -ev

if [ -z "$1" ]; then
  echo "No branch specified using 'master'"
  BRANCH="master"
else
  BRANCH="$1"
fi


APP_PATH="./.ogor-frontend/"

if [ ! -d "$APP_PATH" ]; then
  git clone "git@github.com:ogorlab/ogor-frontend.git" "$APP_PATH"
fi

git -C "$APP_PATH" fetch
git -C "$APP_PATH" checkout "$BRANCH"

cp .env.local "$APP_PATH"

docker build . -t ogor-private-sky-build

rm -rf ./apk-releases
mkdir -p ./apk-releases

docker run --rm \
  --volume "$(pwd)"/apk-releases/:/apk-releases/ \
  ogor-private-sky-build
