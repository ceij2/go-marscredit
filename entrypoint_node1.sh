#!/bin/sh

echo "Starting Node 2"

# Initialize Geth with the genesis file
geth init /genesis.json

# Start Geth and enable mining
exec geth --datadir /data --syncmode "full" --http --http.addr "0.0.0.0" --http.port 8541 --http.api personal,eth,net,web3 --http.vhosts=* --http.corsdomain=* --networkid 110110 --mine --miner.etherbase=0xD21602919e81e32A456195e9cE34215Af504535A --allow-insecure-unlock