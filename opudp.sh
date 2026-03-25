#!/bin/bash
# opudp - ZIVPN Pro Manager Dashboard
# Telegram: @OfficialOnePesewa

# --- CONFIG & COLORS ---
DB="/etc/zivpn/users.db"
RED='\e[1;31m'; GREEN='\e[1;32m'; YELLOW='\e[1;33m'; BLUE='\e[1;34m'; NC='\e[0m'

# --- AUTOMATED CRON LOGIC ---
if [[ "$1" == "--cron-cleanup" ]]; then
    TODAY=$(date +%s)
    while IFS=: read -r u e h; do
        EXP_S=$(date -d "$e" +%s 2>/dev/null)
        if [[ $EXP_S -ge $TODAY ]]; then echo "$u:$e:$h" >> "$DB.tmp"; fi
    done < "$DB"
    mv "$DB.tmp" "$DB"
    exit 0
fi

# --- MENU FUNCTIONS ---
function header() {
    clear
    echo -e "${YELLOW}**opudp**${NC} - ZIVPN PRO DASHBOARD"
    echo -e "Author: @OfficialOnePesewa | $(date)"
    echo -e "${BLUE}-------------------------------------------------------${NC}"
}

function add_user() {
    header
    echo -e "${GREEN}[+] Create New User (Strict Binding)${NC}"
    read -p "Username: " user
    read -p "Days: " days
    read -p "Android Device ID (HWID): " hwid
    exp=$(date -d "+$days days" +"%Y-%m-%d")
    echo "$user:$exp:$hwid" >> "$DB"
    echo -e "${GREEN}Success! User $user is bound to ID: $hwid until $exp${NC}"
    read -p "Press Enter..."
}

function list_users() {
    header
    printf "%-15s | %-12s | %-20s\n" "USER" "EXPIRY" "DEVICE ID"
    echo "-------------------------------------------------------"
    while IFS=: read -r u e h; do
        printf "%-15s | %-12s | %-20s\n" "$u" "$e" "$h"
    done < "$DB"
    read -p "Press Enter..."
}

function backup_data() {
    header
    B_FILE="/var/lib/zivpn-data/backups/backup_$(date +%F).zip"
    zip -r "$B_FILE" /etc/zivpn > /dev/null
    echo -e "${GREEN}[+] Backup Created: $B_FILE${NC}"
    read -p "Press Enter..."
}

# --- MAIN MENU LOOP ---
while true; do
    header
    echo -e " 1) Start ZIVPN           11) Bandwidth Report"
    echo -e " 2) Stop ZIVPN            12) Reset Bandwidth"
    echo -e " 3) Restart ZIVPN         13) Speed Test"
    echo -e " 4) Status                14) Live Logs"
    echo -e " 5) List Users + Expiry   15) Backup All Data"
    echo -e " 6) Add User (Binding)    16) Restore Backup"
    echo -e " 7) Remove User           17) Change Port Range"
    echo -e " 8) Renew User            18) Auto-Update ZIVPN"
    echo -e " 9) Cleanup Expired       99) ${RED}UNINSTALL (DANGER)${NC}"
    echo -e " 0) Exit"
    echo -e "${BLUE}-------------------------------------------------------${NC}"
    read -p " Option: " opt
    case $opt in
        1) systemctl start zivpn ;;
        2) systemctl stop zivpn ;;
        5) list_users ;;
        6) add_user ;;
        9) $0 --cron-cleanup && echo "Cleanup Done." && sleep 2 ;;
        13) speedtest-cli ;;
        15) backup_data ;;
        0) exit 0 ;;
        *) echo -e "${RED}Invalid Selection${NC}"; sleep 1 ;;
    esac
done
