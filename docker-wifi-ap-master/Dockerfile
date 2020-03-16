FROM alpine

RUN apk update && apk add --no-cache \
	bash \
	dnsmasq \
	hostapd \
	ifupdown \
	iptables \
	udev \
    && rm -rf /var/cache/apk/*

COPY dnsmasq.conf /etc/dnsmasq.conf
COPY interfaces /etc/network/interfaces
COPY iptables.ipv4.nat /etc/iptables.ipv4.nat
COPY hostapd.conf /etc/hostapd/hostapd.conf
COPY replace_wifi_pw.sh /opt/replace_wifi_pw.sh
COPY start_services.sh /opt/start_services.sh

CMD /opt/start_services.sh
