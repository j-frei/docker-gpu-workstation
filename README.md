# Docker Files for GPU Workstation
Existing Docker image templates so far:
 - misit/misit-tf-ssh-x11
 - misit/misit-pytorch-ssh-x11
 - misit/misit-ubuntu-ssh-x11
 - misit/misit-ubuntu-ssh-x11-xfce (XFCE-Desktop via SPICE)

## How to build
 - Run the file `build.sh` of the desired image folder on the GPU workstation host.
 - Run the file `build_all_images.sh` to build all images on the GPU workstation host.

## Useful Post-Setup Steps
 - Setup Git configuration:
   ```bash
   git config --global user.name "Vorname Nachname"
   git config --global user.email "meine.email@provider.de"
   ```
 - Set permissions (make mount folders accessible):
   ```bash
   sudo chown -R main:main /storage
   sudo chown -R main:main /data
   ```
 - Set root password:
   ```bash
   sudo passwd root
   ```
## How to use
### Information about CLI/GPU-focused Containers
 - Example for image `misit-tf-ssh-x11`:
   - Example Setup:
     - SSH port: 8022
     - Container name: tf_ssh_gpu01
     - Memory limit: 8GB
     - Disk limit: 20G
   - Spawn/Start new container:
     ```bash
     # On GPU host: Create/Run docker container
     # Example corresponds to GPU wiki page example
     # except:
     # - '-d' parameter for detach was added.
     # - '-p' parameter / port mapping was added.
     # - '-e' for SSH_PORT can be used. If not set, default value: 22
     # - `--restart`-policy was added to survive reboots.
     docker run \
         --gpus '"device=0,1"' \
         --name=tf_ssh_gpu01 \
         -v /storage/share:/share \
         -v /storage/<RZ-Kennung>:/storage \
         -v /data/<RZ-Kennung>:/data \
         --memory=8g \
         -e TF_FORCE_GPU_ALLOW_GROWTH=true \
         -p 8022:22 \
         --storage-opt size=20G \
         --restart unless-stopped \
         -itd \
         misit/misit-tf-ssh-x11:latest

     # On local machine: Connect via ssh
     # Login using default password: template
     ssh -p 8022 main@misit180.informatik.uni-augsburg.de
     # (optional) including X-Forwarding:
     ssh -X -p 8022 main@misit180.informatik.uni-augsburg.de
     # On ssh session: Change default password:
     echo 'main:my_new_password' | chpasswd

     # You can start with your work now...
     ```
   - Remove running container:
     ```bash
     docker stop tf_ssh_gpu01
     docker rm tf_ssh_gpu01
     ```
   - Add / Remove firewall port rules for protected ports (e.g. 80,443):
     - Allow port:
       ```bash
       sudo ufw allow 80
       ```
     - Remove port rule:
       ```bash
       # Look for rules with port 80
       sudo ufw status numbered
       # Remove entries related to port 80
       sudo ufw delete <number>
       ```
 - Example for image `misit-pytorch-ssh-x11`:
   * Follow the steps similar to `misit-tf-ssh-x11`.
   * Use `--ipc=host` for the `docker run` command.
     ```bash
     docker run \
         --gpus '"device=0,1"' \
         --name=pytorch_ssh_gpu01 \
         -v /storage/share:/share \
         -v /storage/<RZ-Kennung>:/storage \
         -v /data/<RZ-Kennung>:/data \
         --memory=8g \
         --ipc=host \
         -p 8022:22 \
         --storage-opt size=20G \
         --restart unless-stopped \
         -itd \
         misit/misit-pytorch-ssh-x11:latest
     ```
 - Example for image `misit-ubuntu-ssh-x11`:
   * Follow the steps similar to `misit-tf-ssh-x11`.
   * Keep out `--gpus ...` parameter for the `docker run` command.
   * Custom SSH_PORT is only for demonstration purposes.
     ```bash
     docker run \
         --name=ubuntu_ssh \
         -v /storage/share:/share \
         -v /storage/<RZ-Kennung>:/storage \
         -v /data/<RZ-Kennung>:/data \
         --memory=8g \
         -e SSH_PORT=8022 \
         -p 8022:8022 \
         --storage-opt size=20G \
         --restart unless-stopped \
         -itd \
         misit/misit-ubuntu-ssh-x11:latest
     ```
 - Additional docker run parameter:
   * `--shm-size=1g` increases shared memory size to 1GB (default: 64MiB)
   * `--memory=8g` sets memory limit to 8GB (default: no limit)

### Information about GUI/XFCE-based Containers
 - How to use SPICE:
   - It is recommended to use `remote viewer` in order to access the SPICE session.
     In Ubuntu 20.04, the APT package is called `virt-viewer`.
 - Example for image `misit-ubuntu-ssh-x11-xfce`:
   * The XSpice/XFCE-Desktop hooks into the `/run-once.sh`-script in order to launch at container startup.
   * Custom SSH_PORT is only for demonstration purposes.
   * Available additional parameters:
     * `SPICE_PORT` (default: 5900)
     * `SPICE_FPS` (default: 25)
     * `SPICE_KEY` (default: "de")
     * `SPICE_RES` (default: "1366x786")
       * You can change the resolution in a SPICE session temporarily with `randr -s <width>x<height>`.
       * The SPICE password is stored in `~/.spice_password`. If you change it, you'll need to restart the container in order to reload the password.
     ```bash
     docker run \
         --name=ubuntu_ssh_xfce \
         -v /storage/share:/share \
         -v /storage/<RZ-Kennung>:/storage \
         -v /data/<RZ-Kennung>:/data \
         -e SSH_PORT=8022 \
         -p 8022:8022 \
         -p 5999:5900 \
         --storage-opt size=20G \
         --restart unless-stopped \
         -itd \
         misit/misit-ubuntu-ssh-x11-xfce:latest
     ```
 - Connect to the SPICE session with the following command on your machine:
   ```bash
   remote-viewer spice://misit180.informatik.uni-augsburg.de:<SPICE_PORT>
   ```
   and enter the SPICE password. The SPICE password is stored in `~/.spice_password` inside the Docker container.

## Scripts

### Jupyter Notebook
Steps to install Jupyter Notebook inside Docker container
<details>

```bash
# Create new Docker container with additional port (e.g. 9876) to 8888
docker run .... -p 9876:8888 ....

# Move setup script into Docker container (captial P for port)
scp -P <SSH_PORT> ./scripts/setup_jupyter_notebook.sh main@misit180.informatik.uni-augsburg.de:~/

# Login
ssh -p <SSH_PORT> main@misit180.informatik.uni-augsburg.de

# Set new SSH password
echo 'main:my_new_password' | chpasswd

# Run setup script & enter password for Jupyter Notebook
sudo ./setup_jupyter_notebook.sh
# ......
# New password:
# Confirm password:
# ......

# Go to $HOME directory and run Jupyter Notebook
sudo -u main sh -c "cd ~/ && nohup jupyter notebook >~/.jupyter-notebook.logs.txt 2>&1 &"

# Jupyter Notebook is now available at (using self-signed HTTPS):
# https://misit180.informatik.uni-augsburg.de:9876/

# [OPTIONAL] Add Jupyter Notebook to launch at container startup
sudo sh -c 'cat >> /run-once.sh <<EOF

# Jupyter Notebook launch
sudo -u main sh -c "cd ~/ && nohup jupyter notebook >~/.jupyter-notebook.logs.txt 2>&1 &"
EOF'
```
</details>

### Jupyter Lab
Steps to install Jupyter Lab inside Docker container
<details>

```bash
# Create new Docker container with additional port (e.g. 9876) to 8888
docker run .... -p 9876:8888 ....

# Move setup script into Docker container (captial P for port)
scp -P <SSH_PORT> ./scripts/setup_jupyter_lab.sh main@misit180.informatik.uni-augsburg.de:~/

# Login
ssh -p <SSH_PORT> main@misit180.informatik.uni-augsburg.de

# Set new SSH password
echo 'main:my_new_password' | chpasswd

# Run setup script & enter password for Jupyter Lab
sudo ./setup_jupyter_lab.sh
# ......
# New password:
# Confirm password:
# ......

# Go to $HOME directory and run Jupyter Lab
sudo -u main sh -c "cd ~/ && nohup jupyter lab >~/.jupyter-lab.logs.txt 2>&1 &"

# Jupyter Lab is now available at (using self-signed HTTPS):
# https://misit180.informatik.uni-augsburg.de:9876/

# [OPTIONAL] Add Jupyter Lab to launch at container startup
sudo -u root sh -c 'cat >> /run-once.sh <<EOF

# Jupyter Lab launch
sudo -u main sh -c "cd ~/ && nohup jupyter lab >~/.jupyter-lab.logs.txt 2>&1 &"
EOF'
```
</details>
