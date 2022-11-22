#!/bin/bash

if [ -x "$(command -v pacman)" ]; then
	pacman -Sy nmap hydra nslookup netdiscover
elif [ -x "$(command -v apt)" ]; then
	apt install nmap hydra nslookup netdiscover
fi
