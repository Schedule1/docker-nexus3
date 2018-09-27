#!/bin/bash

sudo yum install -y wget

wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.rpm"

sudo yum localinstall jdk-8u181-linux-x64

wget https://rpmfind.net/linux/fedora/linux/updates/28/Everything/x86_64/Packages/p/pwgen-2.08-1.fc28.x86_64.rpm

sudo yum localinstall pwgen-2.08-1.fc28.x86_64.rpm
