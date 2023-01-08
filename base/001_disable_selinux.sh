#!/bin/bash

# Disable SELinux and firewalld
echo ">>> Disable SELinux and firewalld"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
systemctl disable --now firewalld >/dev/null 2>&1