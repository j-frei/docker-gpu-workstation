#!/bin/bash

# Set new password if missing
if [ ! -f ~/.spice_password ]; then
    echo $(tr -dc A-Za-z0-9 </dev/urandom | head -c 13) > ~/.spice_password
fi
spice_password=$(cat ~/.spice_password)

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
cd ~

# Start dbus
/etc/init.d/dbus start

# Run Xserver async
/usr/bin/Xorg -config /etc/X11/spiceqxl.xorg.conf -logfile  ~/..spice_Xorg_log :2 & 2> /dev/null

# Run XFCE async
sh -c "DISPLAY=:2 /usr/bin/xfce4-session" &> /dev/null &