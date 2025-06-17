#!/bin/bash
set -e

if [ "$WIFI_MODE" = "PERSONAL" ]; then
    envsubst < /etc/hostapd/hostapd.conf.template > /etc/hostapd/hostapd.conf
elif [ "$WIFI_MODE" = "ENTERPRISE" ] || [ "$WIFI_MODE" = "ENTERPRISE_TLS" ]; then
    envsubst < /etc/hostapd/hostapd.conf.template_WPAENT > /etc/hostapd/hostapd.conf
else
    echo "Unknown mode: $WIFI_MODE"
    exit 1
fi

exec /usr/sbin/hostapd /etc/hostapd/hostapd.conf -dd
