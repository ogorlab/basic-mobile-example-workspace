FROM node:lts as ogor-builder

RUN mkdir -p /build
WORKDIR /build

COPY .ogor-frontend/package.json .
COPY .ogor-frontend/package-lock.json .

RUN npm install --no-optional
COPY .ogor-frontend/ .

# Only build the single page app, excluding the prerender stuff for SEO
RUN npm run build:only-spa

FROM androidsdk/android-30

RUN mkdir -p /var/local/ogor/
WORKDIR /var/local/ogor/

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

COPY apihub-root/ apihub-root/
COPY bin/ bin/
COPY mobile/ mobile/
COPY env.json .
COPY package.json .
COPY octopus.json .

# XXX This is running various scripts; which is really monkaS
RUN npm install --unsafe-perm
# Install ndk and config build env
RUN npm run build-mobile
RUN npm run build-android-apk

# Copy build into the static server root. All static files are server automatically by the Node server.
COPY --from=ogor-builder /build/dist/ mobile/appname/android/app/src/main/assets/nodejs-project/apihub-root/
# XXX Default app path is "/app/loader/index.html", add a simple redirect to go back to the root app
COPY app/ mobile/appname/android/app/src/main/assets/nodejs-project/apihub-root/app/
# Copy handlers injected into the node server
COPY ogorUtils.js mobile/appname/android/app/src/main/assets/nodejs-project/

RUN mkdir -p /apk-releases
VOLUME /apk-releases

COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]


