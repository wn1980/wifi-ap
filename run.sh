#!/usr/bin/env bash

if [ $(uname -m) == 'x86_64' ] 
then
	tag=
elif [ $(uname -m) == 'aarch64' ] 
then 
	tag=:rpi
else
	echo 'not matched platform!'
	exit 0
fi

docker build -t wn1980/wifi-ap${tag} . 
#docker push wn1980/wifi-ap${tag}

docker run -it --rm \
	-e INTERFACE=wlp16s0 \
	-e SSID=${HOSTNAME}-AP \
	-e WPA_PASSPHRASE=passw0rd \
	-e AP_ADDR=10.0.0.1 \
	-e DHCP_RANGE=10.0.0.10,10.0.0.99,8h \
	--network host \
	--privileged \
	--name wifi_ap \
	wn1980/wifi-ap${tag} bash

#	-p 127.0.0.53:53:53/tcp \
#	-p 127.0.0.53:53:53/udp \
