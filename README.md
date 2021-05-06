# Example Workspace

This workspace is meant to be an example workspace for those that want to use PrivateSky ios-edge-agent and android-edge-agent in order to wrap web application into native mobile one for Android and iOS.

## PreInstall
Please check that you NodeJS version is higher then 13. Recomeneded **v14.15.0**

After you clone this repo locally go and edit octopus.json file in order to replace 
**```http://github.com/REPLACE_THIS_IN_THE_OCTOPUS_FILE_WITH_YOUR_REPO_URL```** with your app repo url.
If your app need suplimentary actions to the npm install that is already prepared, please check [Octopus documentation](https://privatesky.xyz/tools/octopus) in order to do necessary changes.

## Installation
Execute **```npm install```** command to install all the necessary deps.

## Mobile App Configuration
Make any changes necessary into the **```mobile/config```** folder in order to customize the name, version, icons of the final mobile app.

## Build
**```npm run build-mobile```** command prepares everything needed by the mobile native applications for Android and iOS platforms.

## Build Android Native App
First you need to ensure that you have installed on your local machine Android SDK.
Edit the file: **"mobile/appname/android/local.properties"** to point to the Android SDK installation path.

Running ```npm run build-android-apk``` will produce the app file. Alternative, you can use Android Studio to build and test it into Emulator. 

## Build iOS Native App
Open the .xcworkspace file with xCode (recommended version >= 12.0), configure the bundle-id, certificates, profiles and build the native app.
