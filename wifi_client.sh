#!/usr/bin/env bash

apk add wpa_supplicant

ip link set wlan0 up
ip addr flush dev wlan0

cat > "$PWD/wifi.conf" <<EOF

ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel

network={
        ssid="xxx"
        scan_ssid=1
        key_mgmt=WPA-PSK
        psk="xxx"
}

EOF

wpa_supplicant -i wlan0 -c wifi.conf

