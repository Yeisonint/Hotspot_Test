# Hotspot Test

## Requirements

- Wifi card unused with drivers installed
- Docker
- Openssl Installed

## Configuration

### Interfaces

Check your interfaces and replace in `.env` file, `ETH_INTERFACE` is neccesary to share internet.

```bash
WIFI_INTERFACE="wlo1"
ETH_INTERFACE="enp3s0"
```

### Hotspot name

Change the value of `HOTSPOT_SSID` in the `.env` file.

### Channel and Band

Change band, channel, protocol and country in hostapd templates inside `hostapd` folder

```bash
# For example 5Ghz, Channel 161
hw_mode=a
channel=161
ieee80211n=0
ieee80211ac=1
ieee80211d=1
ieee8021x=1
country_code=US
```

```bash
# For example 2.4Ghz, Channel 6
hw_mode=g
channel=6
ieee80211n=1
ieee80211ac=0
ieee80211d=1
ieee8021x=0
country_code=US
```

### DHCP

Modify `dhcp/dhcp.conf` file and change the IP and IP range for clients. this is the default configuration:

```text
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 192.168.50.0 netmask 255.255.255.0 {
  range 192.168.50.100 192.168.50.150;
  option routers 192.168.50.1;
  option broadcast-address 192.168.50.255;
  option domain-name-servers 8.8.8.8;
}

```

### Authentication
Depending on the mode (Personal/Enterprise) the authentication is different.

#### WPA2 Personal

Set `WIFI_MODE="PERSONAL"` in .env file and set the network password with `HOTSPOT_PASSWORD` variable.

#### WPA2 Enterprise
Generate the certs for the server using the script `generate_certs.sh`.

```bash
sudo generate_certs.sh
```

##### With TLS
Set `WIFI_MODE="ENTERPRISE_TLS"` in .env file and create clients with `create_client_cert.sh`.

```bash
# for example
sudo create_client_cert.sh yeison
```

Credentials are created in `freeradius/clients` as `.p12` and inside `freeradius/certs` as `.key`/`.pem` pair.

##### With User/Password
Set `WIFI_MODE="ENTERPRISE"` in .env file and modify the file `freeradius/mods-config/files/authorize` and add the clients with the respective passwords.

```text
yeison Cleartext-Password := "yeison123"

estiven   Cleartext-Password := "estiven123"

```

It is very important to leave a line break between users.