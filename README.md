# **GhostBuster**
GhostBuster is an automated brute-forcing attack tool made to enumerate web directories and respective subdirectories. It combines the function of Nmap Security Scanner and Gobuster aiming to ease the enumeration process. 
GhostBuster scans the open port of services HTTP and HTTPS,  and starts the brute force attack using the common web directory wordlist. 

# **Installation**
```
git clone https://github.com/ning9876/GhostBuster 
cd ghostbuster
sudo bash install.sh
sudo chmod +x ghostbuster
```

# **Usage**
`./ghostbuster <url or ip> <thread> <depth> [wordlist]`

# **Credit**
Ghostbuster is a modification of the tool t14m4t, credit is given to the creator MS-WEB-BN. 
