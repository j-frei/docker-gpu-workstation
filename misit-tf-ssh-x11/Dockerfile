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
    apt-get install -y python3-pip python3-venv python3-setuptools python3-wheel && \
    apt-get install -y --no-install-recommends python3-opencv && \
    \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup ssh
RUN mkdir /var/run/sshd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
ENV SSH_PORT=22

# Setup X11 forwarding
RUN sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config
RUN sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config
RUN grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# Add entrypoint script
ADD entrypoint.sh /entrypoint.sh
ADD run-once.sh /run-once.sh
ADD setupUser.sh /setupUser.sh
ADD envparser.py /envparser.py

# Setup random root user password
RUN echo "root:$(tr -dc A-Za-z0-9 </dev/urandom | head -c 40 ; echo '')" | chpasswd

# Run ssh daemon as command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-p", "$SSH_PORT"]
