% DOVECOT(1) Container Image Pages
% Petr Hracek
% Jun 1, 2017

# NAME
dovecot - Secure imap and pop3 server

# DESCRIPTION
Dovecot container for IMAP server.

The container itself consists of:
    - Fedora-26-Boltron baseruntime image
    - dovecot RPM package

Files added to the container during docker build include: /files/start.sh

# USAGE
To get the memcached container image on your local system, run the following:

    docker pull hub.docker.io/modularitycontainers/postfix
    
# VOLUMES

* /var/spool/postfix - contains directories for socket communication with Postfix.

* /var/spool/mail - contains directories for INBOXes.

TODO
# SECURITY IMPLICATIONS
WRITE port

# SEE ALSO
Dovecot page
<https://www.dovecot.org/>
