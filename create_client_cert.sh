#!/bin/bash
set -e

CERT_DIR="freeradius/certs"
CLIENTS_DIR="freeradius/clients"

if [[ ! -f "$CERT_DIR/ca.pem" || ! -f "$CERT_DIR/ca.key" ]]; then
  echo "❌ CA not found. Run generate_certs.sh first."
  exit 1
fi

if [[ -z "$1" ]]; then
  echo "Use: $0 <client_name>"
  exit 1
fi

CLIENT_NAME="$1"

matches=($(find "$CERT_DIR" -type f -name "${CLIENT_NAME}.*"))

if [ ${#matches[@]} -gt 0 ]; then
    echo "Client found '${CLIENT_NAME}':"
    for file in "${matches[@]}"; do
        echo " - $file"
    done

    read -p "¿Regenerate certs files? (y/N): " confirmar
    confirmar=${confirmar,,}

    if [[ "$confirmar" != "y" && "$confirmar" != "yes" ]]; then
        echo "Canceled!"
        exit 1
    fi
fi

openssl genrsa -out "$CERT_DIR/${CLIENT_NAME}.key" 4096
openssl req -new -key "$CERT_DIR/${CLIENT_NAME}.key" -out "$CERT_DIR/${CLIENT_NAME}.csr" -subj "/CN=${CLIENT_NAME}"
openssl x509 -req -in "$CERT_DIR/${CLIENT_NAME}.csr" -CA "$CERT_DIR/ca.pem" -CAkey "$CERT_DIR/ca.key" -CAcreateserial -out "$CERT_DIR/${CLIENT_NAME}.crt" -days 365 -sha256
openssl pkcs12 -export -inkey "$CERT_DIR/${CLIENT_NAME}.key" -in "$CERT_DIR/${CLIENT_NAME}.crt" -certfile "$CERT_DIR/ca.pem" -out "$CLIENTS_DIR/${CLIENT_NAME}.p12"

chown $SUDO_USER:$SUDO_USER $CERT_DIR/${CLIENT_NAME}.key
chown $SUDO_USER:$SUDO_USER $CERT_DIR/${CLIENT_NAME}.crt
chown $SUDO_USER:$SUDO_USER $CERT_DIR/${CLIENT_NAME}.csr
chown $SUDO_USER:$SUDO_USER $CLIENTS_DIR/${CLIENT_NAME}.p12

echo "✅ Certificate generated for client: ${CLIENT_NAME}"
echo "Files:"
echo " - Private key: $CERT_DIR/${CLIENT_NAME}.key"
echo " - Certificate: $CERT_DIR/${CLIENT_NAME}.pem"
echo " - PKCS 12: $CLIENTS_DIR/${CLIENT_NAME}.p12"