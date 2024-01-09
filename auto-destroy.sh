#!/bin/bash
. /etc/bash.bashrc

cd /opt/apps/EKSClass
# Redirect both stdout and stderr to destroy.log
nohup ./destroy.sh > destroy.log 2>&1 &

echo "Started Auto Destroy"
exit 0

