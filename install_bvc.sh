#!/bin/bash

# Copyright (c) 2015,  BROCADE COMMUNICATIONS SYSTEMS, INC
# 
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification,
#  are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this 
# list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice, 
# this list of conditions and the following disclaimer in the documentation and/or 
# other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its contributors 
# may be used to endorse or promote products derived from this software without 
# specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT 
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# author: Alec Rooney
# This script automates the install of BVC version 1.2.  With some changes it might
# work with other versions of BVC, however, it has only been tested with 1.2.
# This script assumes you have installed and setup Ubuntu 14.04 as per Jim Burns 
# video here:  https://www.youtube.com/watch?v=saNnY7A55gM
# The BVC quick start instructions recommend installing BVC in the /opt directory.  
# This script has been tested installing in the /opt directory as per the instructions.
#  
# To use this script do the following:
#
# 1) copy/move this script to the /opt directory
# 2) download bvc-1.2.0.zip and bvc-dependencies-1.2.0.zip from http://www.brocade.com/forms/jsp/vyatta-controller/index.jsp
# 3) copy/move bvc-1.2.0.zip and bvc-dependencies-1.2.0.zip to the /opt directory
# 4) cd to the /opt directory and run the script as follows: sudo ./install_bvc.sh
# 5) if the script runs successfully you should see BVC1.2 installed.  If not, you can always try running the steps manually as per the quick start guide from Brocade 


CURRENT_USER=`logname`
echo "running as $CURRENT_USER"
JAVA_TAR_FILE=server-jre-7u71-linux-x64.tar.gz

if [ ! -f $JAVA_TAR_FILE ]; then
    echo "Need to download java. Downloading..."
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u71-b14/server-jre-7u71-linux-x64.tar.gz
fi

if [ -f $JAVA_TAR_FILE ]; then
    echo "Untarring java..."
    sudo tar oxzf $JAVA_TAR_FILE 
    DIR=`pwd`
    export JAVA_HOME=$DIR/jdk1.7.0_71/jre
    cat ~/.pam_environment | grep -e "JAVA_HOME=$JAVA_HOME"
    if [ $? -ne 0 ]; then
        echo "adding JAVA_HOME=$JAVA_HOME to your ~/.pam_environment file"
        sudo -u $CURRENT_USER echo "JAVA_HOME=$JAVA_HOME" >> ~/.pam_environment 
    else
        echo "JAVA_HOME=$JAVA_HOME is already in your ~/.pam_environment file" 
    fi 
    echo "Installed the following java:"
    $JAVA_HOME/bin/java -version
else
    echo "Error! Could not untar java because $JAVA_TAR_FILE was not found."
fi

apt-get update
apt-get -y install zip unzip curl

curl -sL https://deb.nodesource.com/setup | bash 
apt-get install -y nodejs

apt-get install -y openssh-server

mkdir bvc
chown $CURRENT_USER bvc

BVC_ZIP=bvc-1.2.0.zip
BVC_DEP_ZIP=bvc-dependencies-1.2.0.zip

if [ -f $BVC_ZIP ]; then
    sudo -u $CURRENT_USER unzip -o $BVC_ZIP 
else
    echo "Error! $BVC_ZIP not found."
fi

if [ -f $BVC_DEP_ZIP ]; then
    sudo -u $CURRENT_USER unzip -o $BVC_DEP_ZIP
else
    echo "Error! $BVC_DEP_ZIP not found."
fi

cd bvc
sudo -u $CURRENT_USER -E ./install

if [ $? -eq 0 ]; then
    echo "Successfully installed the following:"
    echo "Java:"
    echo `$JAVA_HOME/bin/java -version`
    echo "zip"
    echo "unzip"
    echo "cURL"
    echo "Node.js:"
    echo `node --version`
    echo "openssh-server"
    echo "BVC version 1.2"
else
    echo "Failed to install BVC and its dependencies!"
fi
