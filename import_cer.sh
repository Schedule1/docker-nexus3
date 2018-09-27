#!/bin/bash

sudo keytool -import -alias schedule1 -file ssl/schedule1.pem -keystore /Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home/jre/lib/security/cacerts -storepass changeit
