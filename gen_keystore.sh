#!/bin/bash

if [ -f "password" ]
then
    rm password
fi

PW=`pwgen -Bs 10 1`
echo ${PW} > password

keytool -genkeypair -keystore schedule1.jks -storepass $PW \
 -keyalg RSA -keysize 2048 -validity 5000 -keypass $PW \
 -dname 'CN=localhost, OU=Nexus3, O=Schedule1, L=Toronto, ST=Ontario, C=CA' 

keytool -exportcert -keystore schedule1.jks -storepass $PW -rfc > schedule1.cert

keytool -importkeystore -srckeystore schedule1.jks -srcstorepass $PW -destkeystore schedule1.p12 -deststorepass $PW -deststoretype PKCS12

keytool -list -keystore schedule1.p12 -storetype PKCS12 -storepass $PW

#openssl pkcs12 -nokeys -in schedule1.p12 -out schedule1.pem

#openssl pkcs12 -nocerts -nodes -in schedule1.p12 -out schedule1.key

cp schedule1.jks ${NEXUS_HOME}/etc/ssl/keystore.jks

PATTERN=s/password/${PW}/g
sed -i ${PATTERN} ${NEXUS_HOME}/etc/jetty/jetty-https.xml


