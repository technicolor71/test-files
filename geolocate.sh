#!/bin/bash

#check to see if the correct packages are installed
PKG=$(sudo dpkg -l | grep -c 'geoip-bin\|geoip-database')

#if they are, echo, if not install them with apt-get
if [ $PKG -eq 2 ]; then
  echo "Packages installed"
else
  echo "Installing packages"
  sudo apt-get -y install geoip-bin geoip-database
fi

##get public ip address
IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

##find geographic location of ip and grab country code
CC=$(geoiplookup $IP | grep -im 1 edition | awk {'print $4'} | cut -d ',' -f 1 | tr '[:upper:]' '[:lower:]')

##assign country code to archive.ubuntu.com url and check to see if it's there
URL=$(curl -sI http://${CC}.archive.ubuntu.com | grep 200 | cut -d ' ' -f 2)

##use sed to update url with new country code
if [ $URL -eq 200 ]; then
  sudo sed -i "s|archive.ubuntu.com|${CC}.archive.ubuntu.com|g" /etc/apt/sources.list
else
  exit
fi
