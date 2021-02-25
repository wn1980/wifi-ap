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

docker rm wifi_ap -f

docker run -d -t \
  -e SSID=${HOSTNAME}-AP \
  -e WPA_PASSPHRASE=passw0rd \
  -e AP_ADDR=192.168.8.1 \
  -e SUBNET=192.168.8.0 \
  --cap-add SYS_ADMIN \
  --network host \
  --privileged \
  --restart unless-stopped \
  --name wifi_ap \
  wn1980/wifi-ap${tag}
