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

### Installs the following programs

#### Command Line Tools

- git
- yay
- rclone
- ohmyzsh
- code command for vscode
- fzf
- nvim
- asdf
- tldr
- man-db
- man-pages

#### Desktop Environment

- kde plasma
- dolphin

#### GUI Tools

- google-chrome
- vscode
- obsidian
- spotify
- qbittorrent
- vesktop
- stremio 