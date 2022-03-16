#!/bin/bash

# Exit immediately if a command exits with a non-zero status. 
set -e 

########
# a. install a specific Apache 2.4 version (the version doesn't matter, just pick one)
########
# # Update system packages (optional)
# yum -y update 

# Install httpd specific version available in centos:centos7.9.2009 according to `yum search --showduplicates httpd`
yum -y install httpd-2.4.6-97.el7.centos.x86_64

# Clean cached data
yum clean all

########
# b. setup a basic homepage in your Apache
# d. setup a redirect from "/contact-page" to the homepage
########
# Copy the basic file page to a hosting location
mkdir -p /var/www/default/public_html
cp index.html /var/www/default/public_html/index.html

# Copy the basic default site configuration to the configuration location
cp 000-default.conf /etc/httpd/conf.d//000-default.conf


########
# c. Optional: enable the server status page in Apache and protect it with basic authentication
########

# Generate the basic authentication file for the username stored in the $USER environment variable
# and the password stored in the $PASS environment variable. 
# Environment variables have been chosen in this particular case for ease of use, but ideally these 
# would be retrieved from a secret store or the file would be generated securely in a CI/CD pipeline.
# 
# Also for ease of use the credentials have been hardcoded to the "safest" username and password 
# combination in the world: admin/admin. Nobody would ever guess it. /s ^_^
USER="admin"
PASS="admin"
htpasswd -cb5 /etc/httpd/.htpasswd $USER $PASS
