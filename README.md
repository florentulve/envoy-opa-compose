# Using Envoy external authorization with Open Policy Agent

Boot

```sh
docker-compose up
```

Get token

```
set token (curl -sS --location --request POST 'http://127.0.0.1:8080/realms/master/protocol/openid-connect/token' \
      --header 'Content-Type: application/x-www-form-urlencoded' \
      --data-urlencode 'password=admin' \
      --data-urlencode 'username=admin' \
      --data-urlencode 'client_id=admin-cli' \
      --data-urlencode 'grant_type=password' | jq -r .access_token)
```

```sh
curl --head -H "Authorization: Bearer $token" -X GET http://localhost:5000/sayho
```

```sh
HTTP/1.1 403 Forbidden
date: Thu, 09 Mar 2023 19:44:30 GMT
server: envoy
content-length: 0
```

```sh
curl --head -H "Authorization: Bearer $token" -X GET http://localhost:5000/sayhi
```

```sh
HTTP/1.1 403 Forbidden
date: Thu, 09 Mar 2023 19:44:30 GMT
server: envoy
content-length: 0
```

```sh
HTTP/1.1 503 Service Unavailable
content-length: 91
content-type: text/plain
date: Thu, 09 Mar 2023 19:45:19 GMT
server: envoy
```
