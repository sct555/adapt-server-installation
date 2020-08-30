#!/bin/bash
# Installation script for Adapt Server on Ubuntu Server 20.04 (AWS EC2 AMI Ubuntu "ubuntu-focal-20.04-amd64-server-20200729)

# Set variables
USER_NAME="Craig Theunissen"
USER_EMAIL="ctheunissen@ayms.co.za"

# Configure git
git config --global user.name $USER_NAME
git config --global user.email $USER_EMAIL

# Add repos for nodejs 12
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

# Install nodejs for repo version
apt-get install -y nodejs

# Install build tools
apt-get install build-essential

# Update npm
npm update -g npm

# Install Grunt CLI
npm install -g grunt-cli

# MongoDB installation
# Import public key used by package management system
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
# ...should respond OK. If error that gnupg not installed, then install gnupg:
# # sudo apt-get install gnupg
# ... and retry public key import

# Create list file for the version of Ubuntu:
# Ubuntu 20.04 (Focal)
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
# Ubuntu 18.04 (Bionic)
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list


# Reload package database
apt-get update

# Install MongoDB packages
apt-get install -y mongodb-org

# To prevent unintended upgrades of MongoDB, pin the package at installed version:
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

# Check following ulimit values:
# ulimit -f (file size): unlimited
# ulimit -t (cpu time): unlimited
# ulimit -v (virtual memory): unlimited [1]
# ulimit -l (locked-in-memory size): unlimited
# ulimit -n (open files): 64000
# ulimit -m (memory size): unlimited [1] [2]
# ulimit -u (processes/threads): 64000

# Start MongoDB - systemd (systemctl)
systemctl start mongod
# If error "Failed to start mongod.service: Unit mongod.service not found" :
# sudo systemctl daemon-reload
# ... then rerun command

# Confirm MongoDB is running
systemctl status mongod

# Set MongoDB to start on boot
systemctl enable mongod

# To stop MongoDB
sudo systemctl stop mongod
# To restart MongoDB
systemctl restart mongod

# Go to folder of choice and clone git repo
git clone https://github.com/adaptlearning/adapt_authoring.git

# Install required npm packages
cd adaptlearning
npm install --production

# Run the install script
node install

echo ""
echo "Type 'node server' to start Adapt Server"

# Check all software versions
# git --version
# node --version
# nodist --version
# nvm --version
# npm --version
# ffmpeg --version
# mongod --version
# grunt --version
# adapt --version
