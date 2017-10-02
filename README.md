# dovecot
Dovecot container for IMAP server.


## How to build the container

```docker build --tag=docker.io/modularitycontainers/dovecot .```


## How to use the dovecot container with built IMAP


Command for running dovecot docker container:
```
docker run -it -e MYHOSTNAME=localhost -e DEBUG_MODE \
    -v /etc/dovecot/:/etc/dovecot \
    dovecot
```

The `/etc/dovecot` directory contains certificates and configuration files used by dovecot.
For more information see `https://wiki2.dovecot.org/SSL/DovecotConfiguration`.

Environment variable DEBUG_MODE is used for debugging proposes
from dovecot point of view.

## Basic dovecot configuration

## How to test the dovecot service

Command for testing dovecot container with
is ```openssl```.

Telnet can not be used because of communication is encrypted.

Testing dovecot service with ```openssl```

TODO
