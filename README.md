# Arch Linux Post-Installation Script

This script automates the post-installation setup of a fresh Arch Linux installation. It provides an interactive menu to choose which components to install, including command-line tools and popular GUI applications.

## Prerequisites

- A fresh Arch Linux installation (see [Archinstall Steps](#archinstall-steps) below)
- Internet connection
- Sudo privileges

## Installation

1. Download the script:
   ```bash
   wget https://raw.githubusercontent.com/mammadu/post-arch-install-script/main/post-install.sh
   ```

2. Make the script executable:
   ```bash
   chmod +x post-install.sh
   ```

3. Run the script:
   ```bash
   ./post-install.sh
   ```

## Interactive Menu

The script provides an interactive menu with the following options:

1. **Command Line Tools**
   - git
   - yay (AUR helper)
   - fzf
   - zsh (set as default shell)
   - oh-my-zsh
   - neovim
   - rclone
   - tldr
   - man-db
   - man-pages
   - asdf

2. **GUI Applications**
   - Google Chrome
   - Visual Studio Code (includes `code` command)
   - Spotify
   - Vesktop (Discord client)
   - Stremio
   - Obsidian
   - qBittorrent

3. **Install All Components**
   - Installs everything listed above

4. **Exit**
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

## Archinstall Steps

Before running this post-installation script, you should complete the initial Arch Linux installation using the official `archinstall` guided installer. Here are the key steps to follow:

1. **Use a Predefined Configuration**
   - You can use the provided `user_configuration.json` from this repository to automate and standardize your installation. Download it with:

     ```bash
     wget https://raw.githubusercontent.com/mammadu/post-arch-install-script/main/user_configuration.json
     ```

   - Then run archinstall with the configuration:

     ```bash
     archinstall --config user_configuration.json
     ```

2. **Select Your Desktop Environment**
   - During the `archinstall` process, choose your preferred desktop environment (e.g., KDE Plasma) when prompted (if not already set in the configuration).

3. **Partition Your Disks**
   - It is recommended to partition your disks as follows:
     - `/boot` (EFI or BIOS boot partition, 1GiB is usually sufficient)
     - `/` (root partition)
     - `swap` (for swap space, typically equal to your RAM size, but can vary based on your needs)
     - `/home` (optional, for user data, you can split this in half with the root partition if desired)
   - Make sure to format and mount these partitions appropriately during the installation.

4. **Create a User Account**
   - During the guided installation, ensure you create a regular user account (not just root). This is required for the post-installation script to work properly and for secure system usage.

5. **Complete the Guided Installation**
   - Follow the remaining prompts in `archinstall` to set your locale, timezone, and other system settings if not already set by the configuration.

Once the base system is installed, a user account is created, and you have rebooted into your new Arch Linux environment, you can proceed with the post-installation script as described above.