#!/bin/bash
# 
# create a image of this instance for semi monthly backups

instance=$(curl http://169.254.169.254/latest/meta-data/instance-id)
name=$(date +%d-%^b-%Y)-backup
description=$(date +%d-%^b-%Y)
aws ec2 create-image --no-reboot --instance-id "$instance" --name "$name" --description "$description"

