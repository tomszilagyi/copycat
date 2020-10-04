#!/bin/bash

# This is the boot script of the copycat docker image
# and not part of the copycat web app.

/etc/init.d/nginx start
sudo -u www-data /copycat/run.sh
