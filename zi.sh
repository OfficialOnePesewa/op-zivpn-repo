#!/bin/bash
# Installer for opudp ZIVPN
# Author: OnePesewa (@OfficialOnePesewa)

clear
# Bold Header for opudp
echo -e "\e[1;33m#######################################################\e[0m"
echo -e "\e[1;37m                 INSTALLING \e[1;32m**opudp**\e[0m"
echo -e "\e[1;33m#######################################################\e[0m"

# OS Detection
OS_NAME=$(lsb_release -is 2>/dev/null || cat /etc/os-release | grep ^NAME | cut -d'=' -f2 | tr -d '"')
OS_VER=$(lsb_release -rs 2>/dev/null || cat /etc/os-release | grep ^VERSION_ID | cut -d'=' -f2 | tr -d '"')
IP=$(curl -s https://api.ipify.org)
COUNTRY=$(curl -s https://ipapi.co/country_name/)

echo -e " SERVER IP     : $IP"
echo -e " OS / VERSION  : $OS_NAME $OS_VER"
echo -e " LOCATION      : $COUNTRY"
echo -e " AUTHOR        : OnePesewa (@OfficialOnePesewa)"
echo -e "\e[1;33m#######################################################\e[0m"

# Install dependencies
apt update && apt install -y wget curl jq bc zip unzip speedtest-cli git lsb-release

# Create necessary directories
mkdir -p /etc/zivpn
mkdir -p /var/lib/zivpn-data/backups

# Download the Menu Script from your repo
# REPLACE 'YOUR_USERNAME' and 'YOUR_REPO' with your actual GitHub details
REPO_URL="https://raw.githubusercontent.com/OfficialOnePesewa/main"
wget -O /usr/bin/opudp "${REPO_URL}/opudp.sh"
chmod +x /usr/bin/opudp

# Download Version File
wget -O /etc/zivpn/version "${REPO_URL}/version"

# Set up Auto-Cleanup Cron Job
(crontab -l 2>/dev/null | grep -v "opudp --cron-cleanup" ; echo "0 0 * * * /usr/bin/opudp --cron-cleanup") | crontab -

echo -e "\e[1;32m[+] Installation Complete!\e[0m"
echo -e "\e[1;33mType \e[1;32mopudp\e[1;33m to open your dashboard.\e[0m"
