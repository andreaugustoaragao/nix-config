#!/bin/bash

#  ____                   _        _   _ _
# |  _ \ ___  _ __  _ __ (_) ___  | \ | (_)___ ___  __ _ _ __
# | |_) / _ \| '_ \| '_ \| |/ _ \ |  \| | / __/ __|/ _` | '_ \
# |  _ < (_) | | | | | | | |  __/ | |\  | \__ \__ \ (_| | | | |
# |_| \_\___/|_| |_|_| |_|_|\___| |_| \_|_|___/___/\__,_|_| |_|
#

# https://github.com/ronniedroid/.dotfiles/blob/master/tag-scripts/Scripts/pmenu.sh

#wm=$(wmctrl -m | grep "Name" | awk '{print $2}')

Poweroff() {
  MENU="rofi -dmenu -c -i -l 4 -p "-PowerOff?" -width 200"
  P=$(echo -e "YES\nNO" | $MENU)

  case "$P" in
  YES) systemctl poweroff ;;
  NO) exit 0 ;;
  esac
}

Reboot() {
  MENU="rofi -dmenu -c -i -l 4 -p "-Reboot?" -width 200"
  R=$(echo -e "YES\nNO" | $MENU)

  case "$R" in
  YES) systemctl reboot ;;
  NO) exit 0 ;;
  esac
}

Logout() {
  MENU="rofi -dmenu -c -i -l 4 -p "-Logout?" -width 200"
  L=$(echo -e "YES\nNO" | $MENU)

  case "$L" in
  YES) bspc quit ;;
  NO) exit 0 ;;
  esac
}

Lock() {
  MENU="rofi -dmenu -c -i -l 4 -p "-Lock?" -width 200"
  L=$(echo -e "YES\nNO" | $MENU)

  case "$L" in
  YES) xset s activate ;;
  NO) exit 0 ;;
  esac
}

MENU="rofi -dmenu -c -i -l 4 -p "-PowerMenu" -width 200"
PM=$(echo -e " Lock\n Logout\n Reboot\n Poweroff" | $MENU)

case "$PM" in
*Poweroff) Poweroff ;;
*Reboot) Reboot ;;
*Logout) Logout ;;
*Lock) Lock ;;
esac
