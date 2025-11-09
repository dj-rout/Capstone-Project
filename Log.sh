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