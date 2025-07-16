#!/bin/bash
set -euo pipefail

# BeerSmith 3 launcher with fixes for various Linux environment quirks.
#
# Some settings might not be desirable under all setups.
# Feel free to tweak and share improvements.
#
# These fixes have worked for the original author as of July 2025.
# They may become unnecessary with future updates to BeerSmith, Wayland,
# Nvidia drivers or other system components.
#
# Logs are stored in /tmp/{beersmith3,beersmith3_errors}.log


if ! bs3_path=$(command -v beersmith3); then
    echo "BeerSmith 3 not found in PATH" >&2
    exit 1
fi


# BeerSmith 3 does not render nicely in dark mode.
# Enforce light Adwaita theme to improve visuals.
export GTK_THEME=Adwaita:light


# Some combination of Wayland/Nvidia GPU/Nvidia drivers may crash with
#    `Error 71 (Protocol error) dispatching to Wayland display`
# Disable "explicit synchronization" feature to work around it.
# Related references:
# - https://ubuntuhandbook.org/index.php/2025/05/nvidia-575-57-08-feature-branch-driver-for-linux
# - https://www.phoronix.com/news/NVIDIA-EGL-Wayland-1.15
export __NV_DISABLE_EXPLICIT_SYNC=1


echo "Launching BeerSmith 3 from $bs3_path"
nohup "$bs3_path" "$@" >>/tmp/beersmith3.log 2>>/tmp/beersmith3_errors.log &
