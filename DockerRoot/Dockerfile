FROM ubuntu:22.04

ARG MAINUSERNAME=main
ARG MAINUSERPASSWORD=template
ARG MAINUSERID=1000
ARG DOCKERGROUPID=968

# Setup basic requirements
RUN apt-get update && apt-get install -y \
  curl wget nano sudo \
  && rm -rf /var/lib/apt/lists/*

# Setup user
RUN useradd -u "$MAINUSERID" -m -s /bin/bash "$MAINUSERNAME"
RUN usermod -aG sudo "$MAINUSERNAME"
RUN echo "$MAINUSERNAME:$MAINUSERPASSWORD" | chpasswd

# Setup Docker group with right GID
RUN groupadd -g "$DOCKERGROUPID" docker

# Install Docker Engine
RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update && apt-get install -y \
  docker-ce docker-ce-cli containerd.io docker-compose-plugin \
  && rm -rf /var/lib/apt/lists/*

RUN usermod -aG docker "$MAINUSERNAME"

CMD ["sleep", "infinity"]