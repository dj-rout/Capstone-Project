#!/bin/bash
# 🌟 Interactive Linux System Maintenance Suite 🌟
# Created by: <Dibyajyoti Rout>

LOG_FILE="$HOME/maintenance.log"
BACKUP_DIR="$HOME/backups"

# === Colors ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# === Helper Functions ===
log_message() {
    echo -e "[${CYAN}$(date '+%Y-%m-%d %H:%M:%S')${NC}] $1" | tee -a "$LOG_FILE"
}

loading_animation() {
    local msg=$1
    echo -e "${YELLOW}$msg...${NC}"
    sleep 1
}

# === Features ===

backup_system() {
    clear
    echo -e "${BLUE}=== 🧰 Starting System Backup ===${NC}"
    log_message "Starting system backup..."
    mkdir -p "$BACKUP_DIR"
    BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
    DIRS_TO_BACKUP=("$HOME/Documents" "$HOME/Desktop" "$HOME/Downloads")

    for dir in "${DIRS_TO_BACKUP[@]}"; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")
            echo -e "${CYAN}Backing up directory:${NC} $dir"
            tar -czf "$BACKUP_DIR/${dir_name}_$BACKUP_DATE.tar.gz" "$dir"
            if [ $? -eq 0 ]; then
                log_message "${GREEN}✔ Successfully backed up $dir_name${NC}"
            else
                log_message "${RED}❌ Failed to back up $dir_name${NC}"
            fi
        else
            echo -e "${YELLOW}⚠ Skipping missing directory:${NC} $dir"
        fi
    done

    # Keep last 5 backups
    cd "$BACKUP_DIR" || exit
    ls -t *.tar.gz 2>/dev/null | tail -n +6 | xargs rm -f 2>/dev/null

    echo ""
    log_message "Backup completed! Location: $BACKUP_DIR"
    echo -e "${GREEN}✅ Backup complete! Files saved in $BACKUP_DIR${NC}"
    read -p "Press Enter to return to menu..."
}

update_system() {
    clear
    echo -e "${BLUE}=== 🔄 System Update & Cleanup ===${NC}"
    log_message "Starting system update and cleanup..."

    echo -e "${YELLOW}Updating package lists...${NC}"
    sudo apt update -y
    echo -e "${GREEN}✔ Package lists updated${NC}"

    echo -e "${YELLOW}Upgrading installed packages...${NC}"
    sudo apt upgrade -y
    echo -e "${GREEN}✔ System upgraded${NC}"

    echo -e "${YELLOW}Removing unnecessary packages...${NC}"
    sudo apt autoremove -y
    sudo apt autoclean -y
    echo -e "${GREEN}✔ Cleanup completed${NC}"

    echo -e "${YELLOW}Clearing temporary files...${NC}"
    sudo rm -rf /tmp/*
    echo -e "${GREEN}✔ Temporary files cleared${NC}"

    log_message "System update and cleanup completed."
    echo -e "${GREEN}✨ System refreshed and cleaned successfully!${NC}"
    read -p "Press Enter to return to menu..."
}

monitor_logs() {
    clear
    echo -e "${BLUE}=== 📊 Monitoring System Health ===${NC}"
    log_message "Starting system log monitoring..."

    echo -e "${YELLOW}Analyzing system logs for errors...${NC}"
    ERROR_COUNT=$(sudo grep -i "error" /var/log/syslog 2>/dev/null | wc -l)

    echo -e "${YELLOW}Checking disk usage...${NC}"
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

    echo -e "${YELLOW}Checking memory usage...${NC}"
    MEM_USAGE=$(free | awk 'NR==2 {printf "%.0f", $3/$2 * 100}')

    echo ""
    if [ "$ERROR_COUNT" -gt 50 ]; then
        echo -e "${RED}⚠ Warning:${NC} $ERROR_COUNT errors found in /var/log/syslog"
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

    echo ""
    log_message "Log monitoring completed."
    echo -e "${CYAN}🩺 System health analysis complete.${NC}"
    read -p "Press Enter to return to menu..."
}

full_maintenance() {
    clear
    echo -e "${BLUE}=== 🧠 Running Full Maintenance Suite ===${NC}"
    log_message "Full maintenance suite started"
    backup_system
    update_system
    monitor_logs
    log_message "Full maintenance completed!"
    echo -e "${GREEN}🚀 All maintenance tasks done successfully!${NC}"
    read -p "Press Enter to return to menu..."
}

view_logs() {
    clear
    echo -e "${BLUE}=== 📜 Viewing Maintenance Logs ===${NC}"
    if [ -f "$LOG_FILE" ]; then
        echo "--------------------------------------"
        tail -n 20 "$LOG_FILE"
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