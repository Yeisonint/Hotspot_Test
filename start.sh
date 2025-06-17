#!/bin/bash

source .env
export RADIUS_IP=$(ip route get 1.1.1.1 | awk '{print $7}')

IP="192.168.50.1/24"

# Verifica si la IP ya está asignada
if ip addr show "$WIFI_INTERFACE" | grep -q "${IP%/*}"; then
    echo "The IP $IP was assigned to $WIFI_INTERFACE. Skipping"
else
    sudo ip addr add "$IP" dev "$WIFI_INTERFACE"
    sudo ip link set "$WIFI_INTERFACE" up
fi

sudo sysctl -w net.ipv4.ip_forward=1

sudo iptables -t nat -A POSTROUTING -o $ETH_INTERFACE -j MASQUERADE
sudo iptables -A FORWARD -i $ETH_INTERFACE -o $WIFI_INTERFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $WIFI_INTERFACE -o $ETH_INTERFACE -j ACCEPT

exec docker compose up --build
