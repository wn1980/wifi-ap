#!/bin/bash

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 10.3.141.0/24 ! -d 10.3.141.0/24 -j MASQUERADE
iptables-save > /etc/iptables/rules.v4

#sysctl -w net.ipv4.ip_forward=1
rfkill block wifi
rfkill unblock wifi
ifup wlp2s0
#iptables-restore < /etc/iptables.ipv4.nat
#/opt/replace_wifi_pw.sh
/usr/sbin/dnsmasq start
echo
echo Here are your Docker WiFi credentials:
egrep '(^ssid|pass)' /etc/hostapd/hostapd.conf
echo
/usr/sbin/hostapd -P /run/hostapd.pid /etc/hostapd/hostapd.conf

