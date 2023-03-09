package envoy.authz
import future.keywords
import input.attributes.request.http as http_request
default allow := false


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

payload := io.jwt.decode(bearer_token)[1]
#metadata := metadata_discovery(payload.iss)

jwks_endpoint := "http://172.16.238.2:8080/realms/master/protocol/openid-connect/certs"
#token_endpoint := metadata.token_endpoint

jwks_request(url) = http.send({
    "url": url,
    "method": "GET",
    "force_cache": true,
    "force_cache_duration_seconds": 3600 # Cache response for an hour
})

jwks := jwks_request(jwks_endpoint).raw_body

allow if {
  action_allowed
  verified
}

action_allowed if {
  glob.match("/sayhi", ["/"], http_request.path)
}


verified := io.jwt.verify_rs256(bearer_token, jwks)

response_headers_to_add["x-foo"] := "bar"
result["response_headers_to_add"] := response_headers_to_add
result["allowed"] := allow
