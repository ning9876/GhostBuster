#!/bin/bash

if [ -x "$(command -v pacman)" ]; then
	pacman -Sy nmap awk gobuster
elif [ -x "$(command -v apt)" ]; then
	apt-get update
	apt install nmap awk gobuster
fi
