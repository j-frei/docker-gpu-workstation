#!/bin/bash

# Set new password if missing
if [ ! -f ~/.spice_password ]; then
    sudo -u main sh -c 'echo $(tr -dc A-Za-z0-9 </dev/urandom | head -c 13) > ~/.spice_password'
fi
spice_password=$(sudo -u main sh -c 'cat ~/.spice_password')

# Set SPICE password
sed -i "s|Option \"SpicePassword\" .*|Option \"SpicePassword\" \"$spice_password\"|" /etc/X11/spiceqxl.xorg.conf

# Set SPICE port
spice_port=${SPICE_PORT:-"5900"}
sed -i "s|Option \"SpicePort\" .*|Option \"SpicePort\" \"$spice_port\"|" /etc/X11/spiceqxl.xorg.conf

# Set SPICE framerate
framerate=${SPICE_FPS:-"25"}
sed -i "s|Option \"SpiceDeferredFPS\" .*|Option \"SpiceDeferredFPS\" \"$framerate\"|" /etc/X11/spiceqxl.xorg.conf

# Set default keyboard map / resolution
keymap=${SPICE_KEY:-"de"}
resolution=${SPICE_RES:-"1366x768"}

#sed -i "s/XKBLAYOUT=.*/XKBLAYOUT=\"$SPICE_KB\"/" /etc/default/keyboard
sed -i "s|Exec=/usr/bin/setxkbmap .*|Exec=/usr/bin/setxkbmap $keymap|" /etc/xdg/autostart/spice_xdg_setkeyboard.desktop
sed -i "s|Exec=/usr/bin/xrandr -s .*|Exec=/usr/bin/xrandr -s $resolution|" /etc/xdg/autostart/spice_xdg_setresolution.desktop

# Move to HOME directory
cd "$(sudo -u main sh -c 'echo $HOME')"

# Start dbus
sudo -u root /etc/init.d/dbus start

# Run Xserver async
if [ -f "/tmp/.X2-lock" ]; then
    sudo -u root rm -f "/tmp/.X2-lock"
    sudo -u root pkill Xorg
fi
sudo -u root /usr/bin/Xorg -config /etc/X11/spiceqxl.xorg.conf -logfile  "$(sudo -u main sh -c 'echo $HOME')/.spice_Xorg_log" :2 & 2> /dev/null

# Run XFCE async
sudo -u main sh -c "DISPLAY=:2 /usr/bin/xfce4-session" &> /dev/null &
