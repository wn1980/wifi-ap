FROM alpine

RUN apk update && apk add --no-cache bash hostapd dnsmasq iptables && rm -rf /var/cache/apk/*

EXPOSE 53/tcp 53/udp

#ADD ./interfaces /etc/network/interfaces

ADD wlanstart.sh /bin/wlanstart.sh

#ENTRYPOINT [ "wlanstart.sh" ]
