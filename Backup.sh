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