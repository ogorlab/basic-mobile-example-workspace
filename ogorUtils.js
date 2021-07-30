/**
 * Middleware called for requests to the local node server, that need to
 * be proxied to the API server.
 *
 * Overrides CORS settings for proxied requests.
 *
 * @param client_request
 * @param client_response
 * @param next
 */
function ogorProxy(client_request, client_response, next) {
  const https = require("https");
  console.log(
    "OGOR API proxy request:",
    client_request.method,
    client_request.url,
    client_request.headers
  );

  // TODO: The api host is hardcoded ATM, we could load it from an env file of sorts.
  //  Unsure if there is one readily loaded somewhere pskWebServer.js, or we need to
  //  make one ourselves.
  const hostname = "api.ogor.ro";
  const options = {
    hostname: hostname,
    port: 443,
    path: client_request.url.replace("/ogor-api", ""),
    method: client_request.method,
    headers: {
      ...client_request.headers,
      Host: hostname,
    },
  };
  try {
    const proxy = https.request(options, function (res) {
      client_response.writeHead(res.statusCode, {
        ...res.headers,
        // TODO: This could in theory be `client_request.headers.host` instead.
        "Access-Control-Allow-Origin": "*",
      });
      res.pipe(client_response, {
        end: true,
      });
    });

    client_request.pipe(proxy, {
      end: true,
    });
  } catch (e) {
    // TODO: API connections errors should be passed via the proxy as well.
    //  Otherwise this will always be 404, so the mobile app will have
    //  certain different behaviours in this scenario.
    console.error("OGOR API proxy error:", e);
    next();
  }
}

/**
 * Called when the node server is initialized. Configures the
 * required middleware to handle requests to the OGOR API.
 *
 * MUST be configured in the server.json file
 * (mobile/config/appname/android/app/src/main/assets/nodejs-project/apihub-root/external-volume/config/server.json)
 *
 * @param server - node http server instance
 */
function ogorHandler(server) {
  server.use("/api/v1/*", ogorProxy);
  server.use("/media/*", ogorProxy);
}

module.exports.ogorHandler = ogorHandler;
