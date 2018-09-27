#!/bin/bash

sudo keytool -delete -alias schedule1 -keystore /Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home/jre/lib/security/cacerts -storepass changeit
