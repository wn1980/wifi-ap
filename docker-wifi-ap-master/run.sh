#!/usr/bin/env bash

set -e

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
	--privileged \
	--net host \
	--name wifi-ap \
	-v /dev/urandom:/dev/random \
	wn1980/wifi-ap${tag}
