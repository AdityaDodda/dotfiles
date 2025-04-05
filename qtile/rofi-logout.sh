#!/bin/bash
choice=$(echo -e "Lock\nLogout\nShutdown\nReboot\nSuspend" | rofi -dmenu -p "System")
case "$choice" in
  Lock)
    betterlockscreen -l
    ;;
  Logout)
    qtile cmd-obj -o cmd -f shutdown
    ;;
  Shutdown)
    systemctl poweroff
    ;;
  Reboot)
    systemctl reboot
    ;;
  Suspend)
    systemctl suspend
    ;;
  *)
    ;;
esac
