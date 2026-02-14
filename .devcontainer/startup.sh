#!/usr/bin/bash

#####
# INTRO
# This file is the "startup-script", that we execute whenever we start our devcontainer.
# Basically, here we want to prepare our development-environment with everything we can't
# do in the Dockerfile, like setting file-permissions of volumes or similar.
#####

# Make sure all volumes mounted are mapped to dev, our user.
sudo chown -R dev:dev /home/dev

#####
# WARNING
# Activate this to REMOVE sudo-access for "dev". That way you can't
# get root inside your container, providing another level of security
#####
# sudo rm /etc/sudoers.d/dev
