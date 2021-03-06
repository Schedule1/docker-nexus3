# Copyright (c) 2016-present Sonatype, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM centos:centos7

MAINTAINER Sonatype <cloud-ops@sonatype.com>

LABEL vendor=Sonatype \
      com.sonatype.license="Apache License, Version 2.0" \
      com.sonatype.name="Nexus Repository Manager base image"

ARG KEYSTORE_PASSWORD
ARG NEXUS_VERSION=3.13.0-01
ARG NEXUS_DOWNLOAD_URL=https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz
ARG NEXUS_DOWNLOAD_SHA256_HASH=5d1890f45e95e2ca74e62247be6b439482d2fe4562a7ec8ae905c4bdba6954ce

ARG JAVA_URL=http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/server-jre-8u181-linux-x64.tar.gz
ARG JAVA_DOWNLOAD_SHA256_HASH=0b26c7fcfad20029e6e0989e678efcd4a81f0fe502a478b4972215533867de1b

ENV JAVA_HOME=/opt/java

# configure nexus runtime
ENV SONATYPE_DIR=/opt/sonatype
ENV NEXUS_HOME=${SONATYPE_DIR}/nexus \
    NEXUS_DATA=/nexus-data \
    NEXUS_CONTEXT='' \
    SONATYPE_WORK=${SONATYPE_DIR}/sonatype-work \
    DOCKER_TYPE='docker'

ARG NEXUS_REPOSITORY_MANAGER_COOKBOOK_VERSION="release-0.5.20180828-161555.3c23098"
ARG NEXUS_REPOSITORY_MANAGER_COOKBOOK_URL="https://github.com/sonatype/chef-nexus-repository-manager/releases/download/${NEXUS_REPOSITORY_MANAGER_COOKBOOK_VERSION}/chef-nexus-repository-manager.tar.gz"

ADD solo.json.erb /var/chef/solo.json.erb

# Install using chef-solo
RUN curl -L https://www.getchef.com/chef/install.sh | bash \
    && /opt/chef/embedded/bin/erb /var/chef/solo.json.erb > /var/chef/solo.json \
    && chef-solo \
       --recipe-url ${NEXUS_REPOSITORY_MANAGER_COOKBOOK_URL} \
       --json-attributes /var/chef/solo.json \
    && rpm -qa *chef* | xargs rpm -e \
    && rpm --rebuilddb \
    && rm -rf /etc/chef \
    && rm -rf /opt/chefdk \
    && rm -rf /var/cache/yum \
    && rm -rf /var/chef

VOLUME ${NEXUS_DATA}

RUN cd /root \
    && yum install -y which wget openssl sudo net-tools \
    && wget http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/p/pwgen-2.08-1.el7.x86_64.rpm \
    && rpm -Uvh pwgen-2.08-1.el7.x86_64.rpm


RUN mkdir /install-scripts

COPY enable-ssl.sh /install-scripts/

COPY ./ssl/schedule1.jks ${NEXUS_HOME}/etc/ssl/keystore.jks

RUN KEYSTORE_PASSWORD_PATTERN=s/password/${KEYSTORE_PASSWORD}/g \
    && sed -i ${KEYSTORE_PASSWORD_PATTERN} ${NEXUS_HOME}/etc/jetty/jetty-https.xml

USER nexus

ENV INSTALL4J_ADD_VM_PARAMS="-Xms1200m -Xmx1200m -XX:MaxDirectMemorySize=2g -Djava.util.prefs.userRoot=${NEXUS_DATA}/javaprefs"

EXPOSE 8081 8443

CMD ["sh", "-c", "${SONATYPE_DIR}/start-nexus-repository-manager.sh"]
