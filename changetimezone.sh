#!/bin/bash
# Backup Existing localtime 
sudo mv /etc/localtime /etc/localtime.bak
# Setting up Local Time to America/Los_Angeles
# if you are unsure abt what timezone path then navigate to  folder /usr/share/zoneinfo ... and use the exact path
sudo ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
