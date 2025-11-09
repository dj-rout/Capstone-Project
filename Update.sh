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