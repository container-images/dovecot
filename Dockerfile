FROM registry.fedoraproject.org/fedora:26

ENV VERSION="0" RELEASE=1 NAME=dovecot ARCH=x86_64
LABEL MAINTAINER "Petr Hracek" <phracek@redhat.com>
LABEL   summary="Dovecot container for IMAP server." \
        name="$FGC/$NAME" \
        version="$VERSION" \
        release="$RELEASE.$DISTTAG" \
        architecture="$ARCH" \
        com.redhat.component="$NAME" \
        usage="docker run -it -e MYHOSTNAME=localhost -v $PASSWD=/etc/passwd --privileged -v $SHADOW=/etc/shadow dovecot" \
        help="Runs dovecot. No dependencies. See Help File belowe for more detailes." \
        description="Dovecot container for IMAP server." \
        io.k8s.description="Dovecot container for IMAP server." \
        io.k8s.diplay-name="3.1" \
        io.openshift.tags="dovecot"

RUN dnf install -y --setopt=tsflags=nodocs \
                 findutils openssl-libs \
                 dovecot passwd shadow-utils postfix && \
    dnf -y clean all

ADD files /files
ADD README.md /

RUN /files/dovecot_config.sh

# Postfix UID based from Fedora
# USER 89

VOLUME ["/var/spool/postfix"]
VOLUME ["/var/spool/mail"]

CMD ["/files/start.sh"]
