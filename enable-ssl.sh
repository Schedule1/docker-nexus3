#!/bin/bash

echo "application-port-ssl=8443" >> ${NEXUS_DATA}/etc/nexus.properties

JETTY='nexus-args=${jetty.etc}/jetty.xml,${jetty.etc}/jetty-http.xml,${jetty.etc}/jetty-https.xml,${jetty.etc}/jetty-requestlog.xml'
echo "$JETTY" >> ${NEXUS_DATA}/etc/nexus.properties