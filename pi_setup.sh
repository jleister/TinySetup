#!/usr/bin/env bash
 
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install vim mpich2 xboxdrv libglew-dev
 
sudo sed -i 's/CODESET=.*/CODESET="guess"/
  s/FONTFACE=.*/FONTFACE="Terminus"/
  s/FONTSIZE=.*/FONTSIZE="12x24"/' /etc/default/console-setup
 
sudo sed -i '
  s/XKBMODEL=.*/XKBMODEL="pc105"/
  s/XKBLAYOUT=.*/XKBLAYOUT="us"/
  s/XKBVARIANT=.*/XKBVARIANT=""/
  s/XKBOPTIONS=.*/XKBOPTIONS="terminate:ctrl_alt_bksp"/' /etc/default/keyboard
 
sudo tee /etc/default/locale <<-EOF
#  File generated by update-locale
LANG=en_US.UTF-8
EOF
 
sudo tee /etc/locale.gen <<-EOF
# This file lists locales that you wish to have built. You can find a list
# of valid supported locales at /usr/share/i18n/SUPPORTED, and you can add
# user defined locales to /usr/local/share/i18n/SUPPORTED. If you change
# this file, you need to rerun locale-gen.
#
 
en_US.UTF-8 UTF-8
EOF
 
sudo locale-gen
 
# sudo dpkg-reconfigure tzdata
 
for file in \
  /etc/hostname \
  /etc/hosts \
  /etc/ssh/ssh_host_rsa_key.pub \
  /etc/ssh/ssh_host_dsa_key.pub
do
  [ -f $file ] && sudo sed -i "s/raspberrypi/$1/" $file
done
 
sudo hostname $1
 
sudo tee /etc/network/interfaces <<-EOF
auto lo
 
iface lo inet loopback
# iface eth0 inet dhcp
 
auto eth0
iface eth0 inet static
address 192.168.3.$2
gateway 192.168.3.1
netmask 255.255.255.0
network 192.168.3.0
broadcast 192.168.3.255
 
# allow-hotplug wlan0
# iface wlan0 inet manual
# wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
# iface default inet dhcp
EOF
 
ssh-keygen -N '' -f /home/pi/.ssh/id_rsa
 
sudo reboot