# Private Sky build workspace for ogor-frontend

Workspace can be used to build and package the [ogor-frontend](https://github.com/ogorlab/ogor-frontend/) app for Android

### Build steps

 - Ensure docker and git is installed, and you have the required access to clone the `ogor-frontend` repository
 - Copy build config file:
   ```
   cp .env.example .env.local
   ```
 - Add the Google Maps key to the `.env.local` file in the `VUE_APP_GOOGLE_MAPS_KEY` variable
 - Run the build script with the ogor-frontend branch you want to build
   ```
   ./build_apk.sh v2.4.3
   ```
 - The .apk file will be in the `apk-releases` folder after the build finishes
   ```
   $ ls -1 ./apk-releases/
   app-release.apk
   output-metadata.json
   ```

### Differences from example repo

This repo is a fork from this [example](https://github.com/PrivateSky/basic-mobile-example-workspace) with the following changes/additions:

 - A [Dockerfile](./Dockerfile) to assist creating a reproducible env for building the APK.
   - This contains a build stage for the [ogor-frontend](https://github.com/ogorlab/ogor-frontend/) app. This custom build does NOT include the pre-render pages for SEO. 
 - A simple [redirect page](./app/loader/index.html) for the index page. Injected into the static page serving in the Docker file
 - Middleware for the node server to handle requests to the OGOR API. (see [ogorUtils.js](./ogorUtils.js))
    - configured in the server.json file
    - intercepts local requests to the API, sends them to the actual API, pipes and adjust the response to handle CORS
 - Various adjustments to the `octopus.json` file, as the frontend build is done in the Dockerfile instead of handled by octopus
 - A convenience script with all the steps for building the apk [build_apk.sh](./build_apk.sh) 

## TODO

 - Adjust apk metadata when building (version, logo, permissions, etc.)
 - Remove landing page from the apk build
 - See todos in [ogorUtils.js](./ogorUtils.js)
 - Add support for proxying WS connections (third-party support might be needed)
