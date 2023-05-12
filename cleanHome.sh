#!/bin/bash
# ----------------------- Clean Home -----------------------
# This script is used to clean the home directory of a user
# It will delete all files and directories except the ones
# specified in the KEEP_DIRS and KEEP_FILES arrays
# ----------------------------------------------------------
# Author: 	Mohamed Zaboub
# Disclaimer 1: USE AT YOUR OWN RISK! I AM NOT RESPONSIBLE FOR ANY DAMAGE CAUSED BY THIS SCRIPT
# Disclaimer 2: This is not a good script, it is just a quick and dirty script to clean home directory
# ----------------------------------------------------------

# List of directories and files to keep
KEEP_DIRS=(Desktop Documents Downloads Music Pictures Public Videos Applications Library go .ssh)
SUB_DIRS_TO_CLEAN=(Desktop Documents Downloads)
KEEP_FILES=(
  .bash_profile
  .bash_history
  .bash_sessions
  .zsh_sessions
  .zsh-update
  .zsh-update.lock
  .zsh_history
  .vimrc
  .zshrc
  .viminfo
  .gitconfig
  .gitignore
  .gitignore_global
  .git-credentials
)

# propmt the user to confirm the deletion
# echo "This script will delete all files and directories in your home directory except the ones specified in the KEEP_DIRS and KEEP_FILES arrays in the script"
# read -p "Are you sure you want to continue? (y/n) " -n 1 -r
# echo ""
# if [[ ! $REPLY =~ ^[Yy]$ ]]
# then
# fi
#   exit 1

delete_list() {
  local files=("$@")

  for file in "${files[@]}"; do
    # Check if the file is a directory
    if [ -d "$file" ]; then
      # Check if the directory should be kept
      if [[ "${KEEP_DIRS[@]}" =~ $(basename "$file") ]]; then
        # Check if the directory should be cleaned
        if [[ "${SUB_DIRS_TO_CLEAN[@]}" =~ $(basename "$file") ]]; then
          # Loop through all files and directories in the subdirectory
          # for subFile in  $(echo "$file"/* "$file"/.*)
          for subFile in "$file"/*; do
            # Delete the file or directory
            echo "Deleting subFile: $subFile"
            rm -rf "$subFile"
          done
        fi
        continue
      fi
    fi

    # Check if the file is a regular file
    if [ -f "$file" ]; then
      # Check if the file should be kept
      if [[ "${KEEP_FILES[@]}" =~ $(basename "$file") ]]; then
        continue
      fi
    fi

    # Delete the file or directory
    echo "Deleting: $file"
    rm -rf "$file"
  done
}

# create a list of visible files and folders in home folder
VISIBLE=()
while IFS= read -r -d $'\0' file; do
  # append to VISIBLE
  VISIBLE+=("$file")
done < <(find ~/* -maxdepth 0 -type f -o -type d -print0)

# create a list of hidden files and folders in home folder
HIDDEN=()
while IFS= read -r -d $'\0' file; do
  # don't add "." and ".. basenames
  if [[ $(basename "$file") == "." || $(basename "$file") == ".." ]]; then
    continue
  fi
  HIDDEN+=("$file")
done < <(find ~/.* -maxdepth 0 -type f -o -type d -print0)

delete_list "${VISIBLE[@]}"
delete_list "${HIDDEN[@]}"
