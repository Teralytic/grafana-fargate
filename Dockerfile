# Maintainer: github.com/ulikabbq
# https://github.com/grafana/grafana-docker
FROM grafana/grafana:6.0.1

# Install chamber
# Grafana images after 5.0.1 require installing as root
USER root
ENV CHAMBER_VERSION=2.3.2
ENV CHAMBER_SHA256SUM=f33637c8d776d65be26d750737056287c9b4ae23e73cea3441efb04fbe6830b8
RUN curl -Ls https://github.com/segmentio/chamber/releases/download/v${CHAMBER_VERSION}/chamber-v${CHAMBER_VERSION}-linux-amd64 > chamber-linux-amd64 && \
    echo "${CHAMBER_SHA256SUM}  chamber-linux-amd64" > chamber_SHA256SUMS && \
    sha256sum -c chamber_SHA256SUMS && \
    rm chamber_SHA256SUMS && \
    chmod a+x chamber-linux-amd64 && \
    mv chamber-linux-amd64 /usr/local/bin/chamber

# Execute entrypoint as grafana user
USER grafana
# Let chamber export secrets as env variables during startup
ENTRYPOINT ["chamber", "exec", "grafana", "--", "/run.sh"]
