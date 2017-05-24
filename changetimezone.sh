#!/bin/bash
# Backup Existing localtime 
sudo mv /etc/localtime /etc/localtime.bak
# Setting up Local Time to America/Los_Angeles
sudo ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
