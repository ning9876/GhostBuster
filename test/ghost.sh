#!/bin/bash
help() {
	echo -e "[${yellow}*${default}] Usage: ./${red}ghostbuster ${default} <url or ip w/o http:// or https://> <threads> <depth: 1-3> [directory wordlist]"
}

report() {
	mkdir Scans Scans/${1} &> /dev/null
	mkdir Output Output/${1} &> /dev/null
}

port_scan() {
	echo -e "[${yellow}*${default}] Target: $1 Number of threads: ${thread}."
	echo -e "[${yellow}*${default}] Checking if the port is open: ${1}...\n"
	sleep 1
	nmap -T4 -Pn -v --open $1 -p 80,443 -oN Scans/${1}/$1.txt
	echo -e "[${yellow}*${default}] Scan finished."
	sleep 1
}

bruteforce() {
   
    if grep -q 80/tcp Scans/${1}/${1}.txt; then
        touch blank.txt
        cat blank.txt > Output/${1}/http-enum_${1}.txt
        cat blank.txt > Output/${1}/http-enum1_${1}.txt
        cat blank.txt > Output/${1}/http-enum2_${1}.txt
        cat blank.txt > Output/${1}/http-enum3_${1}.txt
        cat blank.txt > Output/${1}/http-enum4_${1}.txt

        echo -e "[${yellow}*${default}] Port 80(HTTP) is open. Starting bruteforce...\n"
		sleep 1
		
        # DEPTH 1
        gobuster dir -u http://$1 -w $default -o Output/${1}/http-enum_${1}.txt -t $thread 
        awk '{if (/200/ || /301/){print $1}}' Output/${1}/http-enum_${1}.txt > Output/${1}/http-enum1_${1}.txt
        cat Output/${1}/http-enum1_${1}.txt > Output/${1}/http-enum_${1}.txt
        
        # at this point, enum1_ and enum_ contains the 200-OK dirs on $1 (url)
        # enum_ will be used to store every working directory
        
        # DEPTH 2
        # if depth >= 2 and there are found direrctories
        if (( $depth > 1 )) && [ -s Output/${1}/http-enum_${1}.txt ]; then
            # look through each $1/<first_dirs>/... to find a wordlist that works on each of them
            file="Output/${1}/http-enum1_${1}.txt" 
      	    while read -r line; do
                gobuster dir -u http://$1$line -w $default -o Output/${1}/http-enum2_${1}.txt -t $thread 
                awk '{if (/200/ || /301/){print $1}}' Output/${1}/http-enum2_${1}.txt > Output/${1}/http-enum3_${1}.txt

                # if depth == 3 and there are found directories for $1/$line
                if (( $depth == 3 )) && [ -s Output/${1}/http-enum3_${1}.txt ]; then
                    # save the working subdirs of $line to enum_
                    temp="Output/${1}/http-enum3_${1}.txt"
                    while read -r temps; do
                        echo "$line$temps" >> Output/${1}/http-enum_${1}.txt # append
                    done<$temp

                    # DEPTH 3
                    # use enum3_ to look for working dirs on $1/$line/$line2
                    while read -r line2; do
                        gobuster dir -u http://$1$line$line2 -w $default -o Output/${1}/http-enum2_${1}.txt -t $thread 
                        awk '{if (/200/ || /301/){print $1}}' Output/${1}/http-enum2_${1}.txt > Output/${1}/http-enum4_${1}.txt
                        
                        # save the working subdirs of $line2 to enum_
                        temp2="Output/${1}/http-enum4_${1}.txt"
                        while read -r line3; do
                            echo "$line$line2$line3" >> Output/${1}/http-enum_${1}.txt # append
                        done<$temp2
                    done<$temp
                fi
    	    done<$file
        fi
        
        rm blank.txt
        rm Output/${1}/http-enum1_${1}.txt
        rm Output/${1}/http-enum2_${1}.txt
        rm Output/${1}/http-enum3_${1}.txt
        rm Output/${1}/http-enum4_${1}.txt

        finished_brute $1
    else
        echo -e "[${red}!${default}] Port 80(HTTP) is not open...."
    fi
    
    

    if grep -q 443/tcp Scans/${1}/${1}.txt; then
        touch blank.txt
        cat blank.txt > Output/${1}/https-enum_${1}.txt
        cat blank.txt > Output/${1}/https-enum1_${1}.txt
        cat blank.txt > Output/${1}/https-enum2_${1}.txt
        cat blank.txt > Output/${1}/https-enum3_${1}.txt
        cat blank.txt > Output/${1}/https-enum4_${1}.txt

        echo -e "[${yellow}*${default}] Port 443(HTTPS) is open. Starting bruteforce...\n"
		sleep 1
		
        # DEPTH 1
        gobuster dir -u https://$1 -w $default -o Output/${1}/https-enum_${1}.txt -t $thread 
        awk '{if (/200/ || /301/){print $1}}' Output/${1}/https-enum_${1}.txt > Output/${1}/https-enum1_${1}.txt
        cat Output/${1}/https-enum1_${1}.txt > Output/${1}/https-enum_${1}.txt
        
        # at this point, enum1_ and enum_ contains the 200-OK dirs on $1 (url)
        # enum_ will be used to store every working directory
        
        # DEPTH 2
        # if depth >= 2 and there are found direrctories
        if (( $depth > 1 )) && [ -s Output/${1}/https-enum_${1}.txt ]; then
            # look through each $1/<first_dirs>/... to find a wordlist that works on each of them
            file="Output/${1}/https-enum1_${1}.txt" 
      	    while read -r line; do
                gobuster dir -u https://$1$line -w $default -o Output/${1}/https-enum2_${1}.txt -t $thread 
                awk '{if (/200/ || /301/){print $1}}' Output/${1}/https-enum2_${1}.txt > Output/${1}/https-enum3_${1}.txt

                # if depth == 3 and there are found directories for $1/$line
                if (( $depth == 3 )) && [ -s Output/${1}/https-enum3_${1}.txt ]; then
                    # save the working subdirs of $line to enum_
                    temp="Output/${1}/https-enum3_${1}.txt"
                    while read -r temps; do
                        echo "$line$temps" >> Output/${1}/https-enum_${1}.txt # append
                    done<$temp

                    # DEPTH 3
                    # use enum3_ to look for working dirs on $1/$line/$line2
                    while read -r line2; do
                        gobuster dir -u https://$1$line$line2 -w $default -o Output/${1}/https-enum2_${1}.txt -t $thread
                        awk '{if (/200/ || /301/){print $1}}' Output/${1}/https-enum2_${1}.txt > Output/${1}/https-enum4_${1}.txt
                        
                        # save the working subdirs of $line2 to enum_
                        temp2="Output/${1}/https-enum4_${1}.txt"
                        while read -r line3; do
                            echo "$line$line2$line3" >> Output/${1}/https-enum_${1}.txt # append
                        done<$temp2
                    done<$temp
                fi
    	    done<$file
        fi

        rm blank.txt
        rm Output/${1}/https-enum1_${1}.txt
        rm Output/${1}/https-enum2_${1}.txt
        rm Output/${1}/https-enum3_${1}.txt
        rm Output/${1}/https-enum4_${1}.txt

        finished_brute $1
    else
        echo -e "[${red}!${default}] Port 443(HTTPS) is not open...."
    fi
}

finished_brute() {
        echo -e "[${green}*${default}] Bruteforce finished. Credentials found saved at: Output/${1}/http-enum_${1}.txt or Output/${1}/https-enum_${1}.txt"
        sleep 1
}

	red='\033[0;31m'
	green='\033[0;32m'
	yellow='\033[0;33m'
	default='\033[0;39m'

    thread="16"
    slash="/"


    if [ $# -eq 0 ]; then
                echo -e "[${red}!${default}] Error: No arguments supplied."
                echo -e "[${yellow}*${default}]  Usage: ./${red}ghostbuster ${default} <url or ip w/o http:// or https://> <threads> <depth: 1-3> [directory wordlist]"
		exit
	fi

	if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
		help
		exit
	fi

    if [ ! -z "$2" ]; then
        if [ "$2" -gt "64" ] || [ "$2" -lt "1" ]; then
            echo -e "[${red}!${default}] Maximum number of threads is 64!"
            exit
        else
            thread=$2
        fi
    fi

	if [[ -f $1 ]]; then
		while IFS= read -r line
			do
				sleep 1
				report $line
				port_scan $line
				bruteforce $line $2
		done < "$1"
		exit
	fi
	
	if [ -z "$4" ]; then
        default='Dictionary/Webenum/demo.txt'
        else 
        default=$4
        fi
        
        if [ -z "$3" ]; then
        depth=1
        else
        depth=$3
        fi

	sleep 1
	report $1
	port_scan $1
	bruteforce $1 $2 $depth $default
