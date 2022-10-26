#!/bin/sh

# =============================================
#
# Standard Install for Odoo Development
#
# @author   Aan Kurniawan <aan.phpy@gmail.com>
# @since    1.0
#
# =============================================

# Init & create initial directories
export WORK_DIR=`pwd`

mkdir -p $HOME/app
mkdir -p $HOME/bin
mkdir -p $HOME/Projects/odoo

sudo dpkg --add-architecture i386
sudo apt update && sudo apt upgrade -y


# Install Base Lib
sudo apt install p7zip p7zip-rar p7zip-full -y
sudo apt install apt-transport-https -y 
sudo apt install bash-completion build-essential -y
sudo apt install curl wget git -y
sudo apt install neofetch -y


# For KVM
sudo apt install cpu-checker -y
sudo usermod -aG kvm $USER
sudo apt install qemu qemu-system -y
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release  -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# For Docker
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo service docker start
sudo systemctl disable --now docker.service docker.socket
/usr/bin/dockerd-rootless-setuptool.sh install
echo 'export DOCKER_HOST=unix:///run/user/1000/docker.sock' >> ~/.bashrc
source ~/.bashrc
systemctl --user start docker
systemctl --user enable docker
sudo loginctl enable-linger $(whoami)
sudo dpkg -i $WORK_DIR/docker-desktop-4.8.2-amd64.deb
sudo apt install -f -y


# Install & Setup VIM
sudo apt install vim vim-addon-manager -y
touch $HOME/.vimrc
echo 'set expandtab' >> $HOME/.vimrc
echo 'set backspace=indent,eol,start' >> $HOME/.vimrc
echo 'set smartindent' >> $HOME/.vimrc
echo 'set syntax=on' >> $HOME/.vimrc
echo 'set nowrap' >> $HOME/.vimrc
echo 'set tabstop=4' >> $HOME/.vimrc
echo 'set shiftwidth=4' >> $HOME/.vimrc
echo 'set nocindent' >> $HOME/.vimrc

# Install Python
sudo apt install python3.10 python3.10-dev python3-pip python3-pip-whl \
    python3.10-full python3-virtualenv python3-virtualenvwrapper -y
sudo sudo apt install postgresql -y
sudo add-apt-repository ppa:deadsnakes/ppa -y

# Install NodeJS
wget https://nodejs.org/dist/v16.18.0/node-v16.18.0-linux-x64.tar.xz
tar -xf node-v16.18.0-linux-x64.tar.xz
mv node-v16.18.0-linux-x64 $HOME/app/nodejs
rm -rf node-v16.18.0-linux-x64.tar.xz
echo 'export PATH="$PATH:$HOME/app/nodejs/bin"' >> ~/.bashrc

# Editor
sudo apt install clang exuberant-ctags -y
wget https://az764295.vo.msecnd.net/stable/d045a5eda657f4d7b676dedbfa7aab8207f8a075/code_1.72.2-1665614327_amd64.deb
sudo dpkg -i code_1.72.2-1665614327_amd64.deb
rm -rf code_1.72.2-1665614327_amd64.deb
mkdir -p $HOME/.fonts
wget https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip
unzip Fira_Code_v6.2.zip -d Fira_Code
cp -r Fira_Code/ttf/* ~/.fonts
rm -rf Fira_Code
rm -rf Fira_Code_v6.2.zip

# Restart Shell
exec "$SHELL"
source ~/.bashrc


# Setup ODOO
npm install -g less less-plugin-clean-css sass
sudo apt install git python3-pip build-essential wget python3-dev \
    python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev \
    libsasl2-dev python3-setuptools libjpeg-dev \
    python3-gevent -y
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6.1-2.jammy_amd64.deb
rm -rf wkhtmltox_0.12.6.1-2.jammy_amd64.deb
sudo apt install -f -y


# Setup ODOO 14
git clone https://www.github.com/odoo/odoo --depth 1 --branch 14.0 --single-branch $HOME/Projects/odoo/odoo14
mkdir -p $HOME/Projects/odoo/odoo14/data
mkdir -p $HOME/Projects/odoo/odoo14/custom_addons
touch $HOME/Projects/odoo/odoo14/odoo.conf
echo '[options]' >> $HOME/Projects/odoo/odoo14/odoo.conf
echo 'admin_passwd = admin' >> $HOME/Projects/odoo/odoo14/odoo.conf
echo 'db_host = localhost' >> $HOME/Projects/odoo/odoo14/odoo.conf
echo 'db_port = 5432' >> $HOME/Projects/odoo/odoo14/odoo.conf
echo 'db_user = admin' >> $HOME/Projects/odoo/odoo14/odoo.conf
echo 'db_password = admin' >> $HOME/Projects/odoo/odoo14/odoo.conf
echo 'xmlrpc = True' >> $HOME/Projects/odoo/odoo14/odoo.conf
echo '#xmlrpc_interface = 127.0.0.1' >> $HOME/Projects/odoo/odoo14/odoo.conf
echo 'xmlrpc_port = 8069' >> $HOME/Projects/odoo/odoo14/odoo.conf
echo 'addons_path = /home/aan/Projects/odoo/odoo14/addons,/home/aan/Projects/odoo/odoo14/custom_addons' >> $HOME/Projects/odoo/odoo14/odoo.conf
echo 'data_dir = /home/aan/Projects/odoo/odoo14/data' >> $HOME/Projects/odoo/odoo14/odoo.conf
/usr/bin/python3 -m virtualenv $HOME/Projects/odoo/odoo14/venv
cp $HOME/Projects/odoo/odoo14/requirements.txt $HOME/Projects/odoo/odoo14/requirements-old.txt
cp $WORK_DIR/odoo14-requirements.txt $HOME/Projects/odoo/odoo14/requirements.txt


# Setup ODOO 12
sudo apt install python3.7 python3.7-dev python3.7-venv python3.7-full python3.7-lib2to3 -y
sudo python3.7 -m pip install typing-extensions
git clone https://www.github.com/odoo/odoo --depth 1 --branch 12.0 --single-branch $HOME/Projects/odoo/odoo12
mkdir -p $HOME/Projects/odoo/odoo12/data
mkdir -p $HOME/Projects/odoo/odoo12/custom_addons
touch $HOME/Projects/odoo/odoo12/odoo.conf
echo '[options]' >> $HOME/Projects/odoo/odoo12/odoo.conf
echo 'admin_passwd = admin' >> $HOME/Projects/odoo/odoo12/odoo.conf
echo 'db_host = localhost' >> $HOME/Projects/odoo/odoo12/odoo.conf
echo 'db_port = 5433' >> $HOME/Projects/odoo/odoo12/odoo.conf
echo 'db_user = admin' >> $HOME/Projects/odoo/odoo12/odoo.conf
echo 'db_password = admin' >> $HOME/Projects/odoo/odoo12/odoo.conf
echo 'xmlrpc = True' >> $HOME/Projects/odoo/odoo12/odoo.conf
echo '#xmlrpc_interface = 127.0.0.1' >> $HOME/Projects/odoo/odoo12/odoo.conf
echo 'xmlrpc_port = 8069' >> $HOME/Projects/odoo/odoo12/odoo.conf
echo 'addons_path = /home/aan/Projects/odoo/odoo12/addons,/home/aan/Projects/odoo/odoo12/custom_addons' >> $HOME/Projects/odoo/odoo12/odoo.conf
echo 'data_dir = /home/aan/Projects/odoo/odoo12/data' >> $HOME/Projects/odoo/odoo12/odoo.conf
/usr/bin/python3.7 -m virtualenv $HOME/Projects/odoo/odoo12/venv
cp $HOME/Projects/odoo/odoo12/requirements.txt $HOME/Projects/odoo/odoo12/requirements-old.txt
cp $WORK_DIR/odoo12-requirements.txt $HOME/Projects/odoo/odoo12/requirements.txt

# Postgres 10 Docker for ODOO12
mkdir -p $HOME/docker/postgres10/data
docker pull postgres:10.22-bullseye
docker run -d \
	--name postgres10 \
	-e POSTGRES_PASSWORD=admin \
	-e PGDATA=/var/lib/postgresql/data/pgdata \
	-v $HOME/docker/postgres10/data:/var/lib/postgresql/data \
	-p 5433:5432 \
	postgres:10.22-bullseye
