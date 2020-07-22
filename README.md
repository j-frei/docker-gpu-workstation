# Docker Files for GPU Workstation
Existing Docker image templates so far:
 - misit/misit-tf-ssh

## How to build
 - Run the file `build.sh` of the desired image folder on the GPU workstation host.

## How to use
 - Example for image `misit-tf-ssh`:
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
     docker run \
         --gpus '"device=0,1"' \
         --name=tf_ssh_gpu01 \
         -v /storage/<RZ-Kennung>/docker:/storage \
         -v /data/<RZ-Kennung>/docker:/data \
         -e TF_FORCE_GPU_ALLOW_GROWTH=true \
         -p 8022:22
         -itd \
         misit/misit-tf-ssh:latest
     # On GPU host: Open port
     # (This example uses port 8022 on host)
     sudo ufw allow 8022

     # On local machine: Connect via ssh
     # Login using default password: template
     ssh -p 8022 root@misit180.informatik.uni-augsburg.de
     # On ssh session: Change default password:
     echo 'root:my_new_password' | chpasswd

     # You can start with your work now...
     ```
   - Remove running container:  
     ```bash
     # Stop & remove container
     docker stop tf_ssh_gpu01
     docker rm tf_ssh_gpu01

     # Close UFW port
     # Look for rules with port 8022
     sudo ufw status numbered
     # Remove entries related to port 8022
     sudo ufw delete <number>
     ```
