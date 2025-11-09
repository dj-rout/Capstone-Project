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
