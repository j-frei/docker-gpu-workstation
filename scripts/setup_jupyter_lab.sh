#!/bin/bash

# stop at fail
set -e

getPythonCommands() {
    # Resolve python path AS the 'main' user, so we respect their environment
    # (e.g. conda base env in PyTorch images) rather than the system python.
    pythonCmd=$(sudo -u main sh -c '
        # Prefer whatever "python3" resolves to in the user env;
        # fall back to "python" if needed.
        if cmd=$(which python3 2>/dev/null); then
            echo "$cmd"
        elif cmd=$(which python 2>/dev/null); then
            echo "$cmd"
        else
            echo ""
        fi
    ')

    if [ -z "$pythonCmd" ]; then
        echo "Error: No python3/python found in the main user environment."
        exit 1
    fi

    echo "Using Python: $pythonCmd"
    echo "Version: $(sudo -u main $pythonCmd --version)"

    pipCmd="$pythonCmd -m pip"
}

askPassword() {
    password=""
    while true; do
        echo -n "New password: "
        read -s pass1
        echo
        echo -n "Confirm password: "
        read -s pass2
        echo

        if [ "$pass1" != "$pass2" ]; then
            echo "Passwords are not equal!"
            continue
        fi
        if [ ${#pass1} -le 2 ]; then
            echo "Password needs at least 3 chars!"
            continue
        fi

        echo "Password seems good!"
        password="$pass1"
        break
    done
}


# Setup dependencies
sudo -u root apt-get update -y
sudo -u root apt-get install -y sed openssl

# Resolve the correct python
getPythonCommands

# Install jupyter into same env
sudo -u root $pipCmd install --upgrade pip
sudo -u root $pipCmd install jupyterlab

# Setup config
sudo -u main jupyter lab --generate-config

# Ask password
askPassword

# Generate certs
crt_file="$(sudo -u main sh -c 'echo $HOME')/.jupyter/cert.crt"
key_file="$(sudo -u main sh -c 'echo $HOME')/.jupyter/cert.key"
sudo -u main sh -c "openssl req -new -newkey rsa:4096 -sha256 -nodes -x509 \
    -keyout $key_file -out $crt_file \
    -subj \"/C=DE/ST=Bayern/L=Augsburg/O=Universität Augsburg/OU=Misit/CN=*.informatik.uni-augsburg.de\""

# Hash password
hashPwd=$(sudo -u main $pythonCmd -c "from jupyter_server.auth import passwd; print(passwd(\"$password\"))")

# Setup config file
cfg_file="$(sudo -u main sh -c 'echo $HOME')/.jupyter/jupyter_lab_config.py"
{
    echo "# Overwrite variables"
    echo "c.ServerApp.allow_root = True"
    echo "c.ServerApp.certfile = '$crt_file'"
    echo "c.ServerApp.ip = '0.0.0.0'"
    echo "c.ServerApp.keyfile = '$key_file'"
    echo "c.ServerApp.open_browser = False"
    echo "c.ServerApp.password = '$hashPwd'"
    echo "c.ServerApp.password_required = True"
    echo "c.ServerApp.port = 8888"
    echo "c.ServerApp.quit_button = False"
    echo "import ssl"
    echo "c.ServerApp.ssl_options = {\"ssl_version\": ssl.PROTOCOL_TLSv1_2}"
} | sudo -u main tee -a "$cfg_file" > /dev/null

echo "Script was successful!"
echo "Start Jupyter Lab with: sudo -u main sh -c \"cd ~/ && nohup jupyter lab >~/.jupyter-lab.logs.txt 2>&1 &\""