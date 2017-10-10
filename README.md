# dovecot
dovecot container for IMAP server.


## How to build the container

```docker build --tag=docker .```


## How to use the dovecot container with built IMAP


Command for running dovecot docker container:
```
docker run -it -e MYHOSTNAME=localhost -e DEBUG_MODE \
    -v $PASSWD=/etc/passwd --privileged \
    -v $SHADOW=/etc/shadow \
    dovecot
```

Environment variable DEBUG_MODE is used for debugging proposes
from Postfix and dovecot point of views.
If you want to share host users to container add -v $PASSWD and -v $SHADOW
parameters with --privileged parameter.

## How to test the dovecot service

Command for testing Dovecot container with
is ```openssl```.

Telnet has not to be used because of all
communication is encrypted from the beginning.

Testing dovecot service with ```openssl```

```
openssl s_client -starttls imap -connect localhost:143
```
Testsuite
