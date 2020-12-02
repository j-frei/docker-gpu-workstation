FROM ubuntu:latest

# Skip promps
ENV DEBIAN_FRONTEND=noninteractive

# Adjust timezone
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Install required software
RUN apt-get update && \
    apt-get install -y locales build-essential sudo git jq nano && \
    apt-get install -y openssh-server && \
    apt-get install -y xauth && \
    apt-get install -y python3-pip && \
    \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup ssh
RUN echo 'root:template' | chpasswd
RUN mkdir /var/run/sshd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
ENV SSH_PORT=22

# Setup X11 forwarding
RUN sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config
RUN sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config
RUN grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# Add runonce script
ADD ./runonce.sh /runonce.sh
ADD ./envparser.py /envparser.py

# ADDITIONAL XFCE SECTION
# adapted from: https://github.com/gauthierc/DockerSpiceXfce4/

# Install additional xfce packages
RUN apt-get update && \
    apt-get install -y software-properties-common xserver-xspice x11-xserver-utils && \
    apt-get install -y --no-install-recommends xfce4 && \
    apt-get install -y --no-install-recommends tango-icon-theme xfce4-notifyd xfce4-terminal xubuntu-icon-theme dbus-x11 && \
    \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN locale-gen="de_DE.UTF-8"
#RUN update-locale LANG="de_DE.UTF-8"

# Add xfce-desktop run script
ADD ./spice/rundesktop.sh /rundesktop.sh
RUN sh -c "echo \"\n\
echo 'Start desktop script'\n\
/rundesktop.sh > ~/.rundesktop.log\n\
\" >> /runonce.sh"

# Add spice xdg autostarts
ADD ./spice/spice_xdg_setkeyboard.desktop /etc/xdg/autostart/
ADD ./spice/spice_xdg_setresolution.desktop /etc/xdg/autostart/

# Add x11 spice configuration
ADD ./spice/spice_x11.conf /etc/X11/spiceqxl.xorg.conf

# Set default SPICE settings
ENV SPICE_PORT=5900
ENV SPICE_KEY="de"
ENV SPICE_RES="1366x768"
ENV SPICE_FPS="25"

# Run ssh daemon as command
CMD    ["sh", "-c", "/runonce.sh && /usr/sbin/sshd -D -p $SSH_PORT"]