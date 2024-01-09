#!/bin/bash
. /etc/bash.bashrc

cd /opt/apps/EKSClass
# Redirect both stdout and stderr to deploy.log
nohup ./deploy.sh > deploy.log 2>&1 &

echo "Started Auto Deploy"
exit 0

