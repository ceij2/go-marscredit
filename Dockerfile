FROM golang:1.17-alpine AS build

# Install necessary packages
RUN apk add --no-cache make gcc musl-dev linux-headers git

# Clone the Geth repository
RUN git clone https://github.com/ethereum/go-ethereum.git /go-ethereum

# Set the working directory
WORKDIR /go-ethereum

# Checkout the desired version
RUN git checkout v1.10.25

# Build Geth
RUN make geth

# Use a minimal image for the final build
FROM alpine:latest

# Copy the Geth binary from the build stage
COPY --from=build /go-ethereum/build/bin/geth /usr/local/bin/geth

# Copy the genesis file
COPY genesis.json /genesis.json

# Copy the entrypoint scripts
COPY entrypoint_node1.sh /entrypoint_node1.sh
COPY entrypoint_node2.sh /entrypoint_node2.sh
COPY entrypoint_node3.sh /entrypoint_node3.sh

# Make the scripts executable
RUN chmod +x /entrypoint_node1.sh /entrypoint_node2.sh /entrypoint_node3.sh

# Create the data directory
RUN mkdir -p /data

# Expose necessary ports
EXPOSE 8541
EXPOSE 85411
EXPOSE 8542
EXPOSE 85422
EXPOSE 8543
EXPOSE 85433

# Use the output_enode script to log the enode URL
CMD ["/bin/sh", "-c", "sh /entrypoint_${NODE_ID}.sh"]