#!/bin/bash

# https://www.cyberciti.biz/tips/linux-unix-apple-osx-terminal-ascii-aquarium.html
sudo apt-get install libcurses-perl
sudo apt-get install build-essential

cd /tmp
wget http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/Term-Animation-2.6.tar.gz
tar -zxvf Term-Animation-2.6.tar.gz
cd Term-Animation-2.6/
perl Makefile.PL && make && make test
sudo make install

cd /tmp
wget https://robobunny.com/projects/asciiquarium/asciiquarium.tar.gz
## Extract tar.gz file on Linux or Unix ##
tar -zxvf asciiquarium.tar.gz
cd asciiquarium_1.1/
sudo cp asciiquarium /usr/local/bin
sudo chmod 0755 /usr/local/bin/asciiquarium
