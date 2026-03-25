#!/bin/bash
# opudp Installer - Professional Edition
# Author: OnePesewa (@OfficialOnePesewa)

# Header Branding
clear
echo -e "\e[1;33m#######################################################\e[0m"
echo -e "\e[1;37m                 INSTALLING \e[1;32m**opudp**\e[0m"
echo -e "\e[1;33m#######################################################\e[0m"

# System Detection
OS_NAME=$(lsb_release -is 2>/dev/null || cat /etc/os-release | grep ^NAME | cut -d'=' -f2 | tr -d '"')
OS_VER=$(lsb_release -rs 2>/dev/null || cat /etc/os-release | grep ^VERSION_ID | cut -d'=' -f2 | tr -d '"')
IP=$(curl -s https://api.ipify.org)
# Location detection including Ghana 🇬🇭
COUNTRY=$(curl -s https://ipapi.co/country_name/)
FLAG=$(curl -s https://ipapi.co/country_code/)

echo -e " SERVER IP     : $IP"
echo -e " OS / VERSION  : $OS_NAME $OS_VER"
echo -e " LOCATION      : $COUNTRY $FLAG"
echo -e " AUTHOR        : OnePesewa (@OfficialOnePesewa)"
echo -e "\e[1;33m#######################################################\e[0m"

# Install core dependencies
apt update && apt install -y wget curl jq bc zip unzip speedtest-cli git lsb-release

# Create directory structure
mkdir -p /etc/zivpn
mkdir -p /var/lib/zivpn-data/backups

# Pull the Menu and Version files from your repo
REPO="https://raw.githubusercontent.com/OfficialOnePesewa/op-zivpn-repo/main"
wget -q -O /usr/bin/opudp "${REPO}/opudp.sh"
chmod +x /usr/bin/opudp
wget -q -O /etc/zivpn/version "${REPO}/version"

# Setup daily 12:00 AM Cleanup Cron
(crontab -l 2>/dev/null | grep -v "opudp --cron-cleanup" ; echo "0 0 * * * /usr/bin/opudp --cron-cleanup") | crontab -

echo -e "\e[1;32m[+] opudp installed successfully!\e[0m"
echo -e "\e[1;33mUsage: Type \e[1;32mopudp\e[1;33m to launch your dashboard.\e[0m"
