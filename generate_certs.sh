#!/bin/bash
set -e

source .env

mkdir -p freeradius/certs
rm -Rf freeradius/certs/*
cd freeradius/certs

# DH param
openssl dhparam -out dh.pem 2048

# CA
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.pem -subj "/CN=${HOTSPOT_SSID}"

# Server
openssl genrsa -out server.key 4096
openssl req -new -key server.key -out server.csr -subj "/CN=radius.local"
openssl x509 -req -in server.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out server.pem -days 365 -sha256

# # Client # Use create_client_cert.sh
# openssl genrsa -out client.key 4096
# openssl req -new -key client.key -out client.csr -subj "/CN=user1"
# openssl x509 -req -in client.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out client.pem -days 365 -sha256

sudo chown 101:101 ./*
sudo chmod 640 ./*

echo "Certificates generated in freeradius/certs/"
