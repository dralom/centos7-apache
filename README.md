# centos7-apache
Example of installing and configuring Apache 2.4 on a Centos7 server (docker image used for ease of development)


This is an excercise to implement the following requirements:

```
Create a script (bash or python) which will automated the following installation on a CentOS 7 server:
 a. install a specific Apache 2.4 version (the version doesn't matter, just pick one)
 b. setup a basic homepage in your Apache
 d. setup a redirect from "/contact-page" to the homepage
 c. Optional: enable the server status page in Apache and protect it with basic authentication
```

The solution can be found in the folder [/src](/src/)

- The script [setup.sh](/src/setup.sh) installs and configures the server package with the other files 
from the folder [/src](/src/)
- [index.html](/src/index.html) serves as a placeholder file for the `basic homepage` requirement.
- [000-default.conf](/src/000-default.conf) is the basic configuration for a default site listening on
port 80, which is exposed in the container. This is also where all the magic happens for points `b`, `d` 
and `c`.

## Requirements

- linux environment or WSL2
- docker or docker desktop installed

### How to reproduce this exercise

1. Clone this repo to a folder with the commands:

```bash
git clone https://github.com/dralom/centos7-apache.git
cd centos7-apache
```

2. Build the image by running the script listed below

```bash
.tools/build.sh
```

This will pull the image, copy the files in the [/src](/src/) folder into the image, and execute the 
(/src/setup.sh) script. That script will then install apache and copy the site and config files to 
their predetermined locations.

3. Start the container. By default it will listen on port 18080. Apache itself listens on port 80 in
the container itself, but docker is translating port 18080 on the host to the container's port 80, to 
avoid conflicts on the host machine. 

```bash
.tools/test.sh
```

The output should look similar to this:

```
$ .tools/test.sh
Access the server with http://localhost:18080

http://localhost:18080/contact-page

http://localhost:18080/server-status

f01567b56623571f39e9fc8ea571e50b8972637f9e78e7efa46945ff762305fb
```

You may use the links in the output to access the various subsections.

The credentials for the `/server-status` page are username: `admin` and password `admin` (shhh... don't tell anyone. 😉 )

4. Finally, when done stop the container and it will remove itself.

```bash
.tools/stop-test.sh
```

## CentOS 7 server

As a personal preference I used Docker as an alternative to a virtualization environment. This was the 
best option available to me at the time in terms of ease of access and implementation time. 

The base image chosen is the latest available at the time of writing: `centos:centos7.9.2009`

## Install Apache 2.4

>a. install a specific Apache 2.4 version (the version doesn't matter, just pick one)

The version available in centos:centos7.9.2009 according to `yum search --showduplicates httpd` is
`httpd-2.4.6-97.el7.centos.x86_64`

> b. setup a basic homepage in your Apache

[000-default.conf](/src/000-default.conf)
```conf
<VirtualHost _default_:80>
    # Define where the hosted files can be found in the filesystem
    DocumentRoot "/var/www/default/public_html"
    #...
</VirtualHost>
```

> d. setup a redirect from "/contact-page" to the homepage

[000-default.conf](/src/000-default.conf)
```conf
<VirtualHost _default_:80>
    #...
    # Define a rule to redirect the page /contact-page to the root homepage
    Redirect "/contact-page" "/"
    #...
</VirtualHost>
```

> c. Optional: enable the server status page in Apache and protect it with basic authentication

[000-default.conf](/src/000-default.conf)
```conf
<VirtualHost _default_:80>
    #...
    # Enable the server status page and password protect it.
    # See config script for how the password file is generated. 
    <Location "/server-status">
        SetHandler server-status
        AuthType Basic
        AuthName "Restricted Content"
        AuthUserFile /etc/httpd/.htpasswd
        Require valid-user
    </Location>
    #...
</VirtualHost>
```

[setup.sh](/src/setup.sh)
```sh
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
```

### Proof of authenticity

Initial request received from M.S. ​On Wed, Mar 16, 2022 at 5:59 PM 