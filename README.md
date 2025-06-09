# Arch Linux Post-Installation Script

This script automates the post-installation setup of a fresh Arch Linux installation. It provides an interactive menu to choose which components to install, including command-line tools, the KDE Plasma desktop environment, and popular GUI applications.

## Prerequisites

- A fresh Arch Linux installation
- Internet connection
- Sudo privileges

## Installation

1. Make the script executable:
   ```bash
   chmod +x post-install.sh
   ```

2. Run the script:
   ```bash
   ./post-install.sh
   ```

## Interactive Menu

The script provides an interactive menu with the following options:

1. **Command Line Tools**
   - git
   - yay (AUR helper)
   - rclone
   - oh-my-zsh
   - fzf
   - neovim
   - asdf
   - tldr
   - man-db
   - man-pages

2. **Desktop Environment**
   - KDE Plasma
   - Dolphin (file manager)

3. **GUI Applications**
   - Google Chrome
   - Visual Studio Code
   - Obsidian
   - Spotify
   - qBittorrent
   - Vesktop (Discord client)
   - Stremio

4. **Install All Components**
   - Installs everything listed above

5. **Exit**
   - Exits the script

## Notes

- The script requires an active internet connection
- Some installations may take time depending on your internet speed
- A system reboot is recommended after the installation is complete
- The script uses both pacman (official repositories) and yay (AUR) for package installation
- You can run the script multiple times to install different components
- The script will automatically install base development tools and yay (AUR helper) before showing the menu

## Troubleshooting

If you encounter any issues:

1. Make sure you have sudo privileges
2. Check your internet connection
3. Ensure you have enough disk space
4. If a package fails to install, you can try installing it manually using:
   ```bash
   sudo pacman -S package_name  # for official packages
   yay -S package_name         # for AUR packages
   ``` 