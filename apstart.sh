#!/bin/bash

# Check if running in privileged mode
if [ ! -w "/sys" ] ; then
    echo "[Error] Not running in privileged mode."
    exit 1
fi

#iw phy phy0 interface add uap0 type __ap
iw dev $WLAN interface add uap0 type __ap
INTERFACE=uap0


# Check environment variables
if [ ! "${INTERFACE}" ] ; then
    echo "[Error] An interface must be specified."
    exit 1
fi

echo "Configuring DHCP server (dnsmasq) .."

cat > "/etc/dnsmasq.conf" <<EOF
#Set the wifi interface
interface=${INTERFACE}

#Disable DNS function since we don't need it right now.
port=0

#listen-address=127.0.0.53

#Set the IP range that can be given to clients
dhcp-range=${SUBNET::-1}10,${SUBNET::-1}99,8h

#Set the gateway IP address
dhcp-option=3,${AP_ADDR}

#Set dns server address
#dhcp-option=6,${AP_ADDR}

#Redirect all requests to ${AP_ADDR}
#address=/#/${AP_ADDR}
EOF

echo "Configuring HostAP daemon ..."

cat > "/etc/hostapd.conf" <<EOF
interface=${INTERFACE}

#Set network name and password
ssid=${SSID}
wpa_passphrase=${WPA_PASSPHRASE}
wpa_key_mgmt=WPA-PSK
wpa=2

#Set channel
channel=1

#Set driver
driver=nl80211
EOF

cat > "/etc/network/interfaces" <<EOF
auto $WLAN

#allow-hotplug $WLAN

iface $WLAN inet dhcp
wpa-conf /etc/wpa_supplicant.conf
EOF



#service network-manager stop
#airmon-ng check kill
#ifconfig ${INTERFACE} ${AP_ADDR} netmask 255.255.255.0
#route add default gw ${AP_ADDR}

#echo 1 > /proc/sys/net/ipv4/ip_forward
#iptables --flush
#iptables --table nat --flush
#iptables --delete-chain
#iptables --table nat --delete-chain
#iptables -P FORWARD ACCEPT



ip link set ${INTERFACE} up
ip addr flush dev ${INTERFACE}
ip addr add ${AP_ADDR}/24 dev ${INTERFACE}

#echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_dynaddr
echo 1 > /proc/sys/net/ipv4/ip_forward

cat /proc/sys/net/ipv4/ip_dynaddr 
cat /proc/sys/net/ipv4/ip_forward

iptables -t nat -D POSTROUTING -s ${SUBNET}/24 -j MASQUERADE > /dev/null 2>&1 || true
iptables -t nat -A POSTROUTING -s ${SUBNET}/24 -j MASQUERADE

iptables -D FORWARD -o ${INTERFACE} -m state --state RELATED,ESTABLISHED -j ACCEPT > /dev/null 2>&1 || true
iptables -A FORWARD -o ${INTERFACE} -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -D FORWARD -i ${INTERFACE} -j ACCEPT > /dev/null 2>&1 || true
iptables -A FORWARD -i ${INTERFACE} -j ACCEPT

dnsmasq -C /etc/dnsmasq.conf


#ifconfig $WLAN up
#wpa_supplicant -D nl80211 -i $WLAN -c /etc/wpa_supplicant.conf
#dhcpcd $WLAN

#hostapd -B /etc/hostapd.conf
hostapd /etc/hostapd.conf & 
wait $!


