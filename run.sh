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
	-e WLAN=wlp2s0 \
	-e SSID=${HOSTNAME}-AP \
	-e WPA_PASSPHRASE=passw0rd \
	-e AP_ADDR=10.0.0.1 \
	-e SUBNET=10.0.0.0 \
	-v $PWD/wpa_supplicant.conf:/etc/wpa_supplicant.conf \
	--network host \
	--privileged \
	--name wifi_ap \
	wn1980/wifi-ap${tag} bash
