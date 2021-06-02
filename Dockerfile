FROM alpine

RUN apk update && \
    apk add --no-cache \
    macchanger \
    bash \
    hostapd \
    iptables \
    dhcp \
    iw && \
    rm -rf /var/cache/apk/*

RUN echo "" > /var/lib/dhcp/dhcpd.leases

COPY wlanstart.sh /bin/wlanstart.sh

COPY wifi_client.sh /

ENTRYPOINT ["wlanstart.sh"]
