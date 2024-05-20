#!/bin/zsh

#homebrew env
eval $(/opt/homebrew/bin/brew shellenv)

#Upddate brew package
su "$(dscl . -list /Users | tail -n 4 | head -n 1)" -c "brew update"

#other case
# user >> echo "$(dscl . -list /Users | tail -n 4 | head -n 1)"
echo "Done update packages"

#Upgrade specific package xz utils (CVE-2024-3094)
su "$(dscl . -list /Users | tail -n 1)" -c "brew upgrade xz"
echo "Done upgrade XZ utils"
