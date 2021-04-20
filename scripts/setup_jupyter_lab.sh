#!/bin/bash

getPythonCommands() {
    pythonCmd="python3"
    which $pythonCmd
    if [ "$?" -eq 0 ]; then
        pythonCmd="python3"
    else
        pythonCmd="python"
    fi

    pipCmd="$pythonCmd -m pip"
}

askPassword() {
    password=""
    # Ask for Password
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
apt-get update -y
apt-get install -y sed
apt-get install -y openssl

getPythonCommands

# Install jupyter
$pipCmd install jupyterlab

# Setup config
jupyter lab --generate-config

# Ask password
askPassword

# Generate certs
crt_file="$HOME/.jupyter/cert.crt"
key_file="$HOME/.jupyter/cert.key"
openssl req -new -newkey rsa:4096 -sha256 -nodes -x509 -keyout $key_file -out $crt_file -subj "/C=DE/ST=Bayern/L=Augsburg/O=Universität Augsburg/OU=Misit/CN=*.informatik.uni-augsburg.de"

# Hash password
hashPwd=$($pythonCmd -c "from jupyter_server.auth import passwd; print(passwd(\"$password\"))")

# Setup config file
cfg_file="$HOME/.jupyter/jupyter_lab_config.py"
echo "# Overwrite variables"                                             >> $cfg_file
echo "c.ServerApp.allow_root = True"                                     >> $cfg_file
echo "c.ServerApp.certfile = '$crt_file'"                                >> $cfg_file
echo "c.ServerApp.ip = '0.0.0.0'"                                        >> $cfg_file
echo "c.ServerApp.keyfile = '$key_file'"                                 >> $cfg_file
echo "c.ServerApp.open_browser = False"                                  >> $cfg_file
echo "c.ServerApp.password = '$hashPwd'"                                 >> $cfg_file
echo "c.ServerApp.password_required = True"                              >> $cfg_file
echo "c.ServerApp.port = 8888"                                           >> $cfg_file
echo "c.ServerApp.quit_button = False"                                   >> $cfg_file
echo "import ssl"                                                        >> $cfg_file
echo "c.ServerApp.ssl_options = {\"ssl_version\": ssl.PROTOCOL_TLSv1_2}" >> $cfg_file

echo "Script was successful!"
echo "Start the Jupyter Lab with \"jupyter lab\" or (detached) in background: sh -c \"cd ~/ && nohup jupyter lab >~/.jupyter-lab.logs.txt 2>&1 &\""
