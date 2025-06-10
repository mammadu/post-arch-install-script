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
    if command_exists sudo; then
        sudo pacman -S --noconfirm $1
    else
        pacman -S --noconfirm $1
    fi
}

# Function to install packages using yay
install_yay() {
    print_status "Installing $1..."
    if command_exists yay; then
        yay -S --noconfirm $1
    else
        print_error "yay is not installed. Please install yay first."
        return 1
    fi
}

# Function to initialize system
initialize_system() {
    print_status "Initializing system..."
    
    # Synchronize package database
    print_status "Synchronizing package database..."
    pacman -Sy --noconfirm
    
    # Install sudo
    if ! command_exists sudo; then
        print_status "Installing sudo..."
        pacman -S --noconfirm sudo
    fi
}

# Function to create a new user
create_user() {
    print_status "Checking for existing human users..."
    
    # Check if there are any human users (UID >= 1000)
    if [ "$(getent passwd | awk -F: '$3 >= 1000 && $3 != 65534 {print $1}' | wc -l)" -eq 0 ]; then
        print_warning "No human user found. Creating a new user..."
        
        # Prompt for username
        while true; do
            read -p "Enter username: " username
            if [[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
                break
            else
                print_error "Invalid username. Username must start with a letter or underscore and contain only letters, numbers, underscores, and hyphens."
            fi
        done
        
        # Prompt for password
        while true; do
            read -s -p "Enter password: " password
            echo
            read -s -p "Confirm password: " password_confirm
            echo
            
            if [ "$password" = "$password_confirm" ]; then
                break
            else
                print_error "Passwords do not match. Please try again."
            fi
        done
        
        # Create user and set password
        print_status "Creating user $username..."
        useradd -m -G wheel -s /bin/bash "$username"
        echo "$username:$password" | chpasswd
        
        # Set up sudo access
        print_status "Setting up sudo access..."
        echo "$username ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/$username
        
        print_status "User $username created successfully!"
        print_warning "Please log out and log in as $username to continue with the installation."
        read -p "Press Enter to exit..."
        exit 0
    else
        print_status "Human user found. Continuing with installation..."
    fi
}

# Function to install command line tools
install_cli_tools() {
    print_status "Installing command line tools..."
    
    # Install git first if not present
    if ! command_exists git; then
        print_status "Installing git..."
        install_pacman "git"
    fi
    
    # Install base packages
    install_pacman "man-db man-pages"
    
    # Install yay if not present
    if ! command_exists yay; then
        print_status "Installing yay..."
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    fi
    
    # Install AUR packages
    install_yay "rclone fzf neovim tldr"
    
    # Install oh-my-zsh
    if ! command_exists zsh; then
        print_status "Installing oh-my-zsh..."
        install_pacman "zsh"
        
        # Create .zshrc if it doesn't exist
        if [ ! -f ~/.zshrc ]; then
            touch ~/.zshrc
        fi
        
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install asdf
    if ! command_exists asdf; then
        print_status "Installing asdf..."
        if ! command_exists git; then
            print_error "git is not installed. Please install git first."
            return 1
        fi
        
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
        
        # Create .zshrc if it doesn't exist
        if [ ! -f ~/.zshrc ]; then
            touch ~/.zshrc
        fi
        
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

    # Initialize system first
    initialize_system

    # Check for and create user if needed
    create_user

    # Update system
    print_status "Updating system..."
    if command_exists sudo; then
        sudo pacman -Syu --noconfirm
    else
        pacman -Syu --noconfirm
    fi

    # Install base development tools
    print_status "Installing base development tools..."
    install_pacman "base-devel"

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