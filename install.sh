#!/bin/bash

if [ -x "$(command -v pacman)" ]; then
	pacman -Sy nmap hydra awk gobuster
elif [ -x "$(command -v apt)" ]; then
	apt-get update
	apt install nmap hydra awk gobuster
fi
