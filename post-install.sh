#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_pacman() {
    print_status "Installing $1..."
    if command_exists sudo; then
        sudo pacman -S --noconfirm $1
    else
        pacman -S --noconfirm $1
    fi
}

install_yay() {
    print_status "Installing $1..."
    yay -S --noconfirm $1
}

initialize_system() {
    print_status "Synchronizing package database..."
    pacman -Sy --noconfirm
    if ! command_exists sudo; then
        print_status "Installing sudo..."
        pacman -S --noconfirm sudo
    fi
}

create_user() {
    print_status "Checking for existing human users..."
    if [ "$(getent passwd | awk -F: '$3 >= 1000 && $3 != 65534 {print $1}' | wc -l)" -eq 0 ]; then
        print_warning "No human user found. Creating a new user..."
        while true; do
            read -p "Enter username: " username
            if [[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
                break
            else
                print_error "Invalid username."
            fi
        done
        while true; do
            read -s -p "Enter password: " password
            echo
            read -s -p "Confirm password: " password_confirm
            echo
            if [ "$password" = "$password_confirm" ]; then
                break
            else
                print_error "Passwords do not match."
            fi
        done
        print_status "Creating user $username..."
        useradd -m -G wheel -s /bin/bash "$username"
        echo "$username:$password" | chpasswd
        print_status "Setting up sudo access..."
        echo "$username ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/$username
        print_status "User $username created successfully!"
        print_warning "Please log out and log in as $username to continue."
        read -p "Press Enter to exit..."
        exit 0
    else
        print_status "Human user found. Continuing..."
    fi
}

install_cli_tools() {
    print_status "Installing command line tools..."
    # git, yay, fzf, zsh, ohmyzsh, nvim, rclone, tldr, man-db, man-pages, asdf
    for pkg in git fzf nvim rclone tldr man-db man-pages; do
        if ! command_exists $pkg; then
            install_pacman "$pkg"
        fi
    done
    # yay (AUR helper)
    if ! command_exists yay; then
        print_status "Installing yay..."
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    fi
    # zsh and oh-my-zsh
    if ! command_exists zsh; then
        install_pacman "zsh"
    fi
    if [ ! -f ~/.zshrc ]; then
        touch ~/.zshrc
    fi
    if [ -z "$(grep oh-my-zsh ~/.zshrc 2>/dev/null)" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    if [ "$SHELL" != "/bin/zsh" ]; then
        print_status "Setting zsh as the default shell..."
        chsh -s /bin/zsh "$USER"
    fi
    # asdf
    if ! command_exists asdf; then
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
        echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
        echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.zshrc
    fi
}

install_gui_tools() {
    print_status "Installing GUI tools..."
    # google-chrome, vscode, code command for vscode, spotify, vesktop, stremio, obsidian, qbittorrent
    for pkg in google-chrome visual-studio-code-bin spotify vesktop stremio obsidian qbittorrent; do
        if ! command_exists $(echo $pkg | cut -d'-' -f1); then
            install_yay "$pkg"
        fi
    done
    # Ensure code command is available
    if ! command_exists code; then
        install_yay "visual-studio-code-bin"
    fi
}

show_menu() {
    clear
    echo -e "${GREEN}Arch Linux Post-Installation Script${NC}"
    echo "----------------------------------------"
    echo "1) Command Line Tools"
    echo "2) GUI Tools"
    echo "3) Install All"
    echo "4) Exit"
    echo -n "Enter your choice (1-4): "
}

main() {
    print_status "Starting post-installation setup..."
    initialize_system
    create_user
    print_status "Updating system..."
    if command_exists sudo; then
        sudo pacman -Syu --noconfirm
    else
        pacman -Syu --noconfirm
    fi
    print_status "Installing base-devel..."
    install_pacman "base-devel"
    while true; do
        show_menu
        read -r choice
        case $choice in
            1)
                install_cli_tools
                ;;
            2)
                install_gui_tools
                ;;
            3)
                install_cli_tools
                install_gui_tools
                ;;
            4)
                print_status "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid option. Try again."
                sleep 2
                ;;
        esac
        echo
        read -p "Press Enter to continue..."
    done
}

main