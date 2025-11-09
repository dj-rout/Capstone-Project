view_logs() {
    clear
    if [ -f "$LOG_FILE" ]; then
        echo -e "${CYAN}══════════📜 Recent Log Entries 📜══════════${NC}"
        tail -n 20 "$LOG_FILE"
        echo ""
    else
        echo -e "${RED}No log file found yet.${NC}"
    fi
    read -p "Press Enter to return to menu..."
}