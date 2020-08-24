FROM tensorflow/tensorflow:latest-gpu

# Skip promps
ENV DEBIAN_FRONTEND=noninteractive

# Adjust timezone
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Install required software
RUN apt-get update && \
    apt-get install -y locales build-essential sudo git jq nano && \
    apt-get install -y openssh-server && \
    apt-get install -y xauth && \
    \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup ssh
RUN echo 'root:template' | chpasswd
RUN mkdir /var/run/sshd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# Setup X11 forwarding
RUN sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config
RUN sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config
RUN grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

EXPOSE 22

# Add runonce script
ADD ./runonce.sh /runonce.sh

# Run ssh daemon as command
CMD    ["sh", "-c", "/runonce.sh && /usr/sbin/sshd -D"]
