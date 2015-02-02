#!/bin/sh

#1 Install sublime
wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2

#2 Extract
tar -vxjf Sublime\ Text\ 2.0.2\ x64.tar.bz2

#3 Move sublime to propery place
mv Sublime\ Text\ 2 /opt/


#Set association on TERMINAL
sudo ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/bin/sublime
