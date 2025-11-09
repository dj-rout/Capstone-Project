#!/bin/bash
# 🌟 Interactive Linux System Maintenance Suite 🌟
# Created by: <Dibyajyoti Rout>
#Interactive and Colorful Capstone Project

LOG_FILE="$HOME/maintenance.log"
BACKUP_DIR="$HOME/backups"

# === Colors ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' 

# === Helper Functions ===
log_message() {
    echo -e "[${CYAN}$(date '+%Y-%m-%d %H:%M:%S')${NC}] $1" | tee -a "$LOG_FILE"
}

loading_animation() {
    local msg=$1
    echo -ne "${YELLOW}$msg${NC}"
    for i in {1..3}; do
        echo -n "."
        sleep 0.4
    done
    echo ""
}

progress_bar() {
    local duration=$1
    local interval=0.1
    local steps=$((duration / interval))
    for ((i=0; i<=steps; i++)); do
        local percent=$((i * 100 / steps))
        echo -ne "\r${BLUE}["
        for ((j=0; j<percent/5; j++)); do echo -n "#"; done
        for ((j=percent/5; j<20; j++)); do echo -n " "; done
        echo -ne "] $percent%${NC}"
        sleep $interval
    done
    echo ""
}

# === Features ===

backup_system() {
    clear
    log_message "Starting system backup..."
    mkdir -p "$BACKUP_DIR"
    BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
    DIRS_TO_BACKUP=("$HOME/Documents" "$HOME/Desktop" "$HOME/Downloads")

    for dir in "${DIRS_TO_BACKUP[@]}"; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")
            loading_animation "Backing up $dir_name"
            tar -czf "$BACKUP_DIR/${dir_name}_$BACKUP_DATE.tar.gz" "$dir" 2>/dev/null
            log_message "${GREEN}✔ Successfully backed up $dir_name${NC}"
        fi
    done

    # Keep last 5 backups
    cd "$BACKUP_DIR" || exit
    ls -t *.tar.gz 2>/dev/null | tail -n +6 | xargs rm -f 2>/dev/null

    progress_bar 2
    log_message "Backup completed! Location: $BACKUP_DIR"
    echo -e "${GREEN}✅ Backup complete!${NC}"
}

update_system() {
    clear
    log_message "Starting system update and cleanup..."
    loading_animation "Updating package list"
    sudo apt update -y >/dev/null 2>&1
    loading_animation "Upgrading packages"
    sudo apt upgrade -y >/dev/null 2>&1
    loading_animation "Cleaning up old packages"
    sudo apt autoremove -y >/dev/null 2>&1
    sudo apt autoclean -y >/dev/null 2>&1
    loading_animation "Clearing temporary files"
    sudo rm -rf /tmp/* 2>/dev/null
    progress_bar 2
    log_message "System update and cleanup completed."
    echo -e "${GREEN}✨ System refreshed and cleaned!${NC}"
}

monitor_logs() {
    clear
    log_message "Starting system log monitoring..."
    echo -e "${CYAN}Analyzing logs...${NC}"
    progress_bar 3

    ERROR_COUNT=$(sudo grep -i "error" /var/log/syslog 2>/dev/null | wc -l)
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    MEM_USAGE=$(free | awk 'NR==2 {printf "%.0f", $3/$2 * 100}')

    echo ""
    if [ "$ERROR_COUNT" -gt 50 ]; then
        echo -e "${RED}⚠ Warning:${NC} $ERROR_COUNT errors found in system logs!"
    else
        echo -e "${GREEN}✔ System logs are healthy (${ERROR_COUNT} errors)${NC}"
    fi

    if [ "$DISK_USAGE" -gt 80 ]; then
        echo -e "${RED}⚠ Disk usage is high (${DISK_USAGE}%)${NC}"
    else
        echo -e "${GREEN}✔ Disk usage is normal (${DISK_USAGE}%)${NC}"
    fi

    if [ "$MEM_USAGE" -gt 90 ]; then
        echo -e "${RED}⚠ Memory usage is high (${MEM_USAGE}%)${NC}"
    else
        echo -e "${GREEN}✔ Memory usage is stable (${MEM_USAGE}%)${NC}"
    fi

    log_message "Log monitoring completed."
    echo -e "${CYAN}🩺 System check finished.${NC}"
}

full_maintenance() {
    clear
    echo -e "${YELLOW}Running full maintenance suite...${NC}"
    progress_bar 2
    backup_system
    update_system
    monitor_logs
    log_message "Full maintenance completed!"
    echo -e "${GREEN}🚀 All maintenance tasks done successfully!${NC}"
}

view_logs() {
    clear
    if [ -f "$LOG_FILE" ]; then
        echo -e "${CYAN}Displaying log file:${NC}"
        echo "--------------------------------------"
        tail -n 15 "$LOG_FILE"
        echo "--------------------------------------"
    else
        echo -e "${RED}No log file found.${NC}"
    fi
    read -p "Press Enter to return to menu..."
}

# === Interactive Menu ===
while true; do
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════╗"
    echo "║   🌐 Linux Maintenance Suite 🌐   ║"
    echo "╠══════════════════════════════════╣"
    echo "║ 1. 🧰 Backup System               ║"
    echo "║ 2. 🔄 Update & Cleanup            ║"
    echo "║ 3. 📊 Monitor Logs                ║"
    echo "║ 4. 🧠 Full Maintenance            ║"
    echo "║ 5. 📜 View Logs                   ║"
    echo "║ 6. 🚪 Exit                        ║"
    echo "╚══════════════════════════════════╝"
    echo -e "${NC}"
    read -p "👉 Choose an option [1-6]: " choice

    case $choice in
        1) backup_system ;;
        2) update_system ;;
        3) monitor_logs ;;
        4) full_maintenance ;;
        5) view_logs ;;
        6) echo -e "${YELLOW}👋 Exiting... Stay productive!${NC}"; exit 0 ;;
        *) echo -e "${RED}❌ Invalid option. Try again.${NC}"; sleep 1 ;;
    esac
done
