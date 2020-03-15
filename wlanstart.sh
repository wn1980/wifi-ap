#!/bin/bash


# Check if running in privileged mode
if [ ! -w "/sys" ] ; then
    echo "[Error] Not running in privileged mode."
    exit 1
fi

# Check environment variables
if [ ! "${INTERFACE}" ] ; then
    echo "[Error] An interface must be specified."
    exit 1
fi

# Default values
true ${SUBNET:=192.168.254.0}
true ${AP_ADDR:=192.168.254.1}
true ${PRI_DNS:=8.8.8.8}
true ${SEC_DNS:=8.8.4.4}
true ${SSID:=wifi-ap}
true ${CHANNEL:=11}
true ${WPA_PASSPHRASE:=passw0rd}
true ${HW_MODE:=g}

if [ ! -f "/etc/hostapd.conf" ] ; then
    cat > "/etc/hostapd.conf" <<EOF
interface=${INTERFACE}
${DRIVER+"driver=${DRIVER}"}
ssid=${SSID}
hw_mode=${HW_MODE}
channel=${CHANNEL}
wpa=2
wpa_passphrase=${WPA_PASSPHRASE}
wpa_key_mgmt=WPA-PSK
# TKIP is no secure anymore
#wpa_pairwise=TKIP CCMP
wpa_pairwise=CCMP
rsn_pairwise=CCMP
wpa_ptk_rekey=600
wmm_enabled=1

# Activate channel selection for HT High Througput (802.11an)

${HT_ENABLED+"ieee80211n=1"}
${HT_CAPAB+"ht_capab=${HT_CAPAB}"}

# Activate channel selection for VHT Very High Througput (802.11ac)

${VHT_ENABLED+"ieee80211ac=1"}
${VHT_CAPAB+"vht_capab=${VHT_CAPAB}"}
EOF

fi


echo "Configuring DHCP server (dnsmasq) .."

cat > "/etc/dnsmasq.conf" <<EOF
interface=lo,uap0
no-dhcp-interface=lo,wlan0
bind-interfaces
server=8.8.8.8
dhcp-range=10.3.141.50,10.3.141.255,12h
EOF

echo "Starting DHCP server (dnsmasq) .."
/usr/sbin/dnsmasq start

# Capture external docker signals
trap 'true' SIGINT
trap 'true' SIGTERM
trap 'true' SIGHUP

echo "Starting HostAP daemon ..."
/usr/sbin/hostapd /etc/hostapd.conf &

wait $!


