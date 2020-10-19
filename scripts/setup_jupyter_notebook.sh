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
        echo -n "New Password: "
        read -s pass1
        echo
        echo -n "Confirm password: "
        read -s pass2
        echo

        if [ $pass1 != $pass2 ]; then
            echo "Passwords are not equal!"
            continue
        fi
        if [ ${#pass1} -le 2 ]; then
            echo "Password needs to at least 3 chars!"
        fi

        echo "Password seems good!"
        password=$pass1
        break
    done
}


# Setup dependencies
apt-get update -y
apt-get install -y sed
apt-get install -y openssl

getPythonCommands

# Install jupyter
$pipCmd install jupyter

# Setup config
jupyter notebook --generate-config

# Ask password
askPassword

# Generate certs
crt_file="$HOME/.jupyter/cert.crt"
key_file="$HOME/.jupyter/cert.key"
openssl req -new -newkey rsa:4096 -sha256 -nodes -x509 -keyout $key_file -out $crt_file -subj "/C=DE/ST=Bayern/L=Augsburg/O=Universität Augsburg/OU=Misit/CN=*.informatik.uni-augsburg.de"

# Hash password
hashPwd=$($pythonCmd -c "from notebook.auth import passwd; print(passwd(\"$password\"))")

# Setup config file
cfg_file="$HOME/.jupyter/jupyter_notebook_config.py"
echo "# Overwrite variables"                                               >> $cfg_file
echo "c.NotebookApp.allow_root = True"                                     >> $cfg_file
echo "c.NotebookApp.certfile = '$crt_file'"                                >> $cfg_file
echo "c.NotebookApp.ip = '0.0.0.0'"                                        >> $cfg_file
echo "c.NotebookApp.keyfile = '$key_file'"                                 >> $cfg_file
echo "c.NotebookApp.open_browser = False"                                  >> $cfg_file
echo "c.NotebookApp.password = '$hashPwd'"                                 >> $cfg_file
echo "c.NotebookApp.password_required = True"                              >> $cfg_file
echo "c.NotebookApp.port = 8888"                                           >> $cfg_file
echo "import ssl"                                                          >> $cfg_file
echo "c.NotebookApp.ssl_options = {\"ssl_version\": ssl.PROTOCOL_TLSv1_2}" >> $cfg_file

echo "Script was successful!"
echo "Start the Jupyter Notebook with \"nohup jupyter notebook &\""
