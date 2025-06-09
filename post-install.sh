#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[!]${NC} $1"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages using pacman
install_pacman() {
    print_status "Installing $1..."
    sudo pacman -S --noconfirm $1
}

# Function to install packages using yay
install_yay() {
    print_status "Installing $1..."
    yay -S --noconfirm $1
}

# Function to install command line tools
install_cli_tools() {
    print_status "Installing command line tools..."
    install_pacman "man-db man-pages"
    install_yay "rclone fzf neovim tldr"
    
    # Install oh-my-zsh
    if ! command_exists zsh; then
        print_status "Installing oh-my-zsh..."
        install_pacman "zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install asdf
    if ! command_exists asdf; then
        print_status "Installing asdf..."
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
        echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
        echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.zshrc
    fi
}

# Function to install desktop environment
install_desktop() {
    print_status "Installing KDE Plasma and Dolphin..."
    install_pacman "plasma-meta dolphin"
    
    # Enable and start KDE Plasma
    print_status "Enabling KDE Plasma..."
    systemctl enable sddm
    systemctl start sddm
}

# Function to install GUI applications
install_gui_apps() {
    print_status "Installing GUI applications..."
    install_yay "google-chrome visual-studio-code-bin obsidian spotify qbittorrent vesktop stremio"
}

# Function to display menu
show_menu() {
    clear
    echo -e "${GREEN}Arch Linux Post-Installation Script${NC}"
    echo "----------------------------------------"
    echo "Please select components to install:"
    echo
    echo "1) Command Line Tools"
    echo "   - git, yay, rclone, oh-my-zsh, fzf, nvim, asdf, tldr, man-db, man-pages"
    echo
    echo "2) Desktop Environment"
    echo "   - KDE Plasma, Dolphin"
    echo
    echo "3) GUI Applications"
    echo "   - Google Chrome, VSCode, Obsidian, Spotify, qBittorrent, Vesktop, Stremio"
    echo
    echo "4) Install All Components"
    echo
    echo "5) Exit"
    echo
    echo -n "Enter your choice (1-5): "
}

# Main installation function
main() {
    print_status "Starting post-installation setup..."

    # Update system
    print_status "Updating system..."
    sudo pacman -Syu --noconfirm

    # Install base development tools
    print_status "Installing base development tools..."
    sudo pacman -S --noconfirm base-devel git

    # Install yay (AUR helper)
    if ! command_exists yay; then
        print_status "Installing yay..."
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    fi

    while true; do
        show_menu
        read -r choice

        case $choice in
            1)
                install_cli_tools
                ;;
            2)
                install_desktop
                ;;
            3)
                install_gui_apps
                ;;
            4)
                install_cli_tools
                install_desktop
                install_gui_apps
                ;;
            5)
                print_status "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid option. Please try again."
                sleep 2
                ;;
        esac

        echo
        read -p "Press Enter to continue..."
    done
}

# Run main function
main 