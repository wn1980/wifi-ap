FROM alpine

RUN apk update && apk add --no-cache bash hostapd dnsmasq iptables && rm -rf /var/cache/apk/*

EXPOSE 53 53/udp

#ADD ./interfaces /etc/network/interfaces

ADD apstart.sh /bin/apstart.sh

#ENTRYPOINT [ "apstart.sh" ]
