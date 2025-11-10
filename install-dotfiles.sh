#!/bin/sh

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/Bulbasaur854/dotfiles"
REPO_NAME="dotfiles"

is_stow_installed() {
  pacman -Qi "stow" &> /dev/null
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

cd ~

# Check if repo already exists on system
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  echo "Removing old configs"
  rm -rf ~/.config/backgrounds ~/.config/hypr/hyprlock.conf ~/.config/starship.toml ~/.bashrc

  cd "$REPO_NAME"
  stow backgrounds
  stow bashrc
  stow hyprlock
  stow starship
else
  exho "Failed to clone the repository"
  exit 1
fi
