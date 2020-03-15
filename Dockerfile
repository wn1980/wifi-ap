FROM alpine

RUN apk update && apk add --no-cache bash hostapd dnsmasq iptables && rm -rf /var/cache/apk/*

ADD wlanstart.sh /bin/wlanstart.sh

ENTRYPOINT [ "wlanstart.sh" ]
