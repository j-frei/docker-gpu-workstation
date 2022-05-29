# Root via Docker

## Info
This setup is useful to setup an VM-like Ubuntu environment with root access on instances with Docker privileges but no sudo permissions.

**Note that access to Docker privileges are equivalent to sudo permissions.**  
This setup only avoids the use of exploits to obtain an actual root shell and helps to avoid conflicts with the system administrator.

When using Docker inside the "fake"-VM, it communicates with the host Docker socket, and thus, things like volume mounts need to be set from the perspective of the host in order to work as expected.

## How to Use

Create the Docker image:  
```bash
# Build image
./setup.sh
```

Run the instance (with example output):  
```bash
# Might adapt the volume mount(s) in run.sh
# default: volume_mnt="/home/$username/docker"

# Start container
./run.sh
NVIDIA-runtime found
<Container Hash>
Run: docker exec -it -u <user-id> dockerroot_<username>_<user-id>-17006 bash
```

Enter the shell:  
```bash
docker exec -it -u <user-id> dockerroot_<username>_<user-id>-17006 bash

# In shell: Change password!
passwd <username>
```
