FROM docker.io/envoyproxy/envoy:v1.24.1

COPY entrypoint.sh /
RUN chmod 500 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
