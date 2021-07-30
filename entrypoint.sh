#!/usr/bin/env bash

set -ev

npm run build-android-apk
cp -r mobile/appname/android/app/build/outputs/apk/release/* /apk-releases/
