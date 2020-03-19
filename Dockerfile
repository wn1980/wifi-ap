FROM alpine

RUN apk update && apk add --no-cache bash hostapd dnsmasq iptables \
	&& rm -rf /var/cache/apk/*

ADD apstart.sh /bin/apstart.sh

ENTRYPOINT [ "apstart.sh" ]
