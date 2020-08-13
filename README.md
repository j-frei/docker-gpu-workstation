# Docker Files for GPU Workstation
Existing Docker image templates so far:
 - misit/misit-tf-ssh-x11
 - misit/misit-pytorch-ssh-x11
 - misit/misit-ubuntu-ssh-x11

## How to build
 - Run the file `build.sh` of the desired image folder on the GPU workstation host.

## How to use
 - Example for image `misit-tf-ssh-x11`:
   - Example Setup:
     - SSH port: 8022
     - Container name: tf_ssh_gpu01  
   - Spawn/Start new container:
     ```bash
     # On GPU host: Create/Run docker container
     # Example corresponds to GPU wiki page example
     # except:
     # - '-d' parameter for detach was added.
     # - '-p' parameter / port mapping was added.
     # - `--restart`-policy was added to survive reboots.
     docker run \
         --gpus '"device=0,1"' \
         --name=tf_ssh_gpu01 \
         -v /storage/<RZ-Kennung>/docker:/storage \
         -v /data/<RZ-Kennung>/docker:/data \
         -e TF_FORCE_GPU_ALLOW_GROWTH=true \
         --restart unless-stopped \
         -p 8022:22 \
         -itd \
         misit/misit-tf-ssh-x11:latest

     # On local machine: Connect via ssh
     # Login using default password: template
     ssh -p 8022 root@misit180.informatik.uni-augsburg.de
     # (optional) including X-Forwarding:
     ssh -X -p 8022 root@misit180.informatik.uni-augsburg.de
     # On ssh session: Change default password:
     echo 'root:my_new_password' | chpasswd

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
         -v /storage/<RZ-Kennung>/docker:/storage \
         -v /data/<RZ-Kennung>/docker:/data \
         --ipc=host \
         --restart unless-stopped \
         -p 8022:22 \
         -itd \
         misit/misit-pytorch-ssh-x11:latest
     ```
 - Example for image `misit-ubuntu-ssh-x11`:
   * Follow the steps similar to `misit-tf-ssh-x11`.
   * Keep out `--gpus ...` parameter for the `docker run` command.  
     ```bash
     docker run \
         --name=pytorch_ssh_gpu01 \
         -v /storage/<RZ-Kennung>/docker:/storage \
         -v /data/<RZ-Kennung>/docker:/data \
         --restart unless-stopped \
         -p 8022:22 \
         -itd \
         misit/misit-ubuntu-ssh-x11:latest
     ```

