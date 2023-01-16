package envoy.authz

import input.attributes.request.http as http_request
default allow = false


metadata_discovery(issuer) = http.send({
    "url": concat("", [issuer, "/.well-known/openid-configuration"]),
    "method": "GET",
    "force_cache": true,
    "force_cache_duration_seconds": 86400 # Cache response for 24 hours
}).body

bearer_token := t {
    v := http_request.headers.authorization
    startswith(v, "Bearer ")
    t := substring(v, count("Bearer "), -1)
}

#payload := io.jwt.decode(bearer_token)[1]
#metadata := metadata_discovery(payload.iss)

jwks_endpoint := "http://oidc:8080/realms/master/protocol/openid-connect/certs"
#token_endpoint := metadata.token_endpoint

jwks_request(url) = http.send({
    "url": url,
    "method": "GET",
    "force_cache": true,
    "force_cache_duration_seconds": 3600 # Cache response for an hour
})

jwks := jwks_request(jwks_endpoint).raw_body

verified := io.jwt.verify_rs256(bearer_token, jwks)

allow = response {
  #print("verified", verified, "jwks", jwks)
  #trace(jwks_endpoint)
  verified == true
  http_request.method == "GET"
  http_request.headers["x-allowed"] == "True"
  response := {
      "allowed": true,
      "headers": {"X-Auth-User": "1234"}
  }
}

allow = response {
  glob.match("/sayhi", ["/"], http_request.path)
  response := {
    "allowed": true,
    "headers": {"X-Auth-User": "1234"}
  }
}
