FROM almalinux:8

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm &&\
    dnf install -y https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el8-release-latest.rpm &&\
    dnf install -y \
        htgettoken \
        osg-ca-certs \
        xrootd-client \
        &&\
    dnf clean all

COPY examples/ /usr/local/bin/
