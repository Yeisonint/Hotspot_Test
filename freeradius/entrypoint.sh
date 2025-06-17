#!/bin/bash
set -e

for mod in /etc/freeradius/mods-available/*; do
  mod_name=$(basename "$mod")
  target="/etc/freeradius/mods-enabled/$mod_name"

  [[ "$mod_name" == "eap" ]] && continue
  [[ "$mod_name" == *.rst ]] && continue

  mod_so="/usr/lib/freeradius/rlm_${mod_name}.so"
  if [[ -f "$mod_so" ]]; then
    [ -e "$target" ] || ln -s "../mods-available/$mod_name" "$target"
  else
    echo "Skipping unavailable module: $mod_name"
  fi
done

rm /etc/freeradius/mods-enabled/sqlcounter
rm /etc/freeradius/mods-enabled/sql
rm /etc/freeradius/mods-enabled/redis
rm /etc/freeradius/mods-enabled/rediswho
rm /etc/freeradius/mods-enabled/sqlippool
rm /etc/freeradius/mods-enabled/ldap
rm /etc/freeradius/mods-enabled/sql_map
rm /etc/freeradius/mods-enabled/rest

if [ -n "$RADIUS_SECRET" ] && [ -n "$HOSTAPD_IP" ]; then
  envsubst < /etc/freeradius/clients.conf.template > /etc/freeradius/clients.conf
else
  echo "RADIUS_SECRET and HOSTAPD_IP must be set"
  exit 1
fi

if [ "$WIFI_MODE" = "ENTERPRISE" ]; then
  mv /eap /etc/freeradius/mods-enabled/eap
elif [ "$WIFI_MODE" = "ENTERPRISE_TLS" ]; then
  mv /eap_tls /etc/freeradius/mods-enabled/eap
fi

exec "$@"
