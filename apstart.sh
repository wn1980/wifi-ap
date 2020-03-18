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

echo "Configuring DHCP server (dnsmasq) .."

cat > "/etc/dnsmasq.conf" <<EOF
#Set the wifi interface
interface=${INTERFACE}

listen-address=127.0.0.1

#Set the IP range that can be given to clients
dhcp-range=10.0.0.10,10.0.0.100,8h

#Set the gateway IP address
dhcp-option=3,10.0.0.1

#Set dns server address
dhcp-option=6,10.0.0.1

#Redirect all requests to 10.0.0.1
address=/#/10.0.0.1
EOF

echo "Configuring HostAP daemon ..."

if [ ! -f "/etc/hostapd.conf" ] ; then
    cat > "/etc/hostapd.conf" <<EOF
interface=${INTERFACE}

#Set network name
ssid=${SSID}

#Set channel
channel=1

#Set driver
driver=nl80211
EOF

fi

#service network-manager stop
#airmon-ng check kill
ifconfig ${INTERFACE} 10.0.0.1 netmask 255.255.255.0
route add default gw 10.0.0.1

#echo 1 > /proc/sys/net/ipv4/ip_forward
#iptables --flush
#iptables --table nat --flush
#iptables --delete-chain
#iptables --table nat --delete-chain
#iptables -P FORWARD ACCEPT

dnsmasq -C /etc/dnsmasq.conf
hostapd /etc/hostapd.conf &
#service apache2 start

wait $!
