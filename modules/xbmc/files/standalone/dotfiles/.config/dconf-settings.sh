#!/bin/bash

dconf write /org/gnome/desktop/wm/preferences/theme "'Adwaita-X-dark'"
dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita'"
dconf write /org/gnome/desktop/interface/icon-theme "'Faenza'"
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type "'nothing'"
dconf write /org/gnome/desktop/session/idle-delay 'uint32 0'
dconf write /org/gnome/desktop/screensaver/lock-enabled false
dconf write /org/gnome/desktop/background/picture-uri "'file:///$HOME/.background.jpg'"
dconf write /org/gnome/desktop/background/picture-options "'zoom'"
