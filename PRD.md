# Product Requirements Document (PRD)

## Project Overview

Create a post installation program/script to setup a fresh arch linux installation.

## Skills Required

- python or bash

## Key Features

### System initialization

- synchronize package database (i.e. pacman -Sy)
- install sudo

### User Management

- Check for existing users
- If no regular user exists:
    - Prompt for username (with validation)
    - Prompt for password (with confirmation)
    - Create user with:
        - Home directory
        - Wheel group membership
        - Bash shell
    - Set up sudo access
    - Exit for security (requiring new login)

### Installs the following programs (only if not already installed)

#### Command Line Tools

- git
- yay
- fzf
- install and set zsh as default shell
- ohmyzsh
- nvim
- rclone
- tldr
- man-db
- man-pages
- asdf

#### GUI Tools

- google-chrome
- vscode
- code command for vscode
- spotify
- vesktop
- stremio
- obsidian
- qbittorrent
