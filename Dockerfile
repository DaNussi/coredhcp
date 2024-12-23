# Start with a base Go image
FROM golang:1.22 as builder

# Set working directory inside the container
WORKDIR /app

# Copy the source code into the container
COPY . .

# Install CoreDHCP using go install
WORKDIR /app/cmds/coredhcp
RUN go build -o /coredhcp

# Reduce the size of the final image
FROM golang:1.22

# Copy the CoreDHCP binary from the builder image
WORKDIR /app
COPY --from=builder /coredhcp /app/coredhcp

# Expose the default DHCPv6 port
EXPOSE 547/udp

# Set the default configuration file
ENV COREDHCP_PLUGIN_CONFIG_FILE=/app/config.yaml

# Command to run the server
ENTRYPOINT ["/app/coredhcp"]
CMD ["--conf", "/app/config.yml"]
