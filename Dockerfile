FROM centos:7

RUN yum install -y yum-utils make epel-release \
    && yum-builddep -y ostree \
    && yum clean all
WORKDIR /usr/local/src
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]