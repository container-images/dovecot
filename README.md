# dovecot
Dovecot container for IMAP server.


## How to build the container

```docker build --tag=docker.io/modularitycontainers/dovecot .```


## How to use the dovecot container with enabled IMAP

Command for running dovecot docker container with plain text authentication:
```
docker run -it -e MYHOSTNAME=localhost -e PLAIN_AUTH=yes -e DEBUG_MODE \
    -v $(pwd)/root/users:/etc/dovecot/users:Z \
    dovecot -d docker.io/modularitycontainers/dovecot
```

Environment variable DEBUG_MODE is used for debugging proposes
from dovecot point of view.

## ENVIRONMENT VARIABLES

The image recognizes the following environment variables that you can set during initialization
by passing `-e VAR=VALUE` to the Docker run command.

|    Variable name    |        Description                                                  |
| :------------------ | --------------------------------------------------------------------|
|    `PLAIN_AUTH`     | Allows to specify plain text authentication                         |
|    `DEBUG_MODE`     | Used for debugging proposes like installation `rsyslog` RPM package |

In case of usage `PLAIN_AUTH` add to run command mapping your user file to ``/etc/dovecot/users` file.
Example format:
```
USER:PASSWD:1000:1000::<mail_directory>
```
Replace USER and PASSWD with your defined user and passwd respectively.

## How to test the dovecot service

Command for testing dovecot container with
is ```openssl```.

Telnet can not be used because of communication is encrypted.

For testing example my `users` file looks like:
```
dummy:{PLAIN}redhat:1000:1000::/var/
```

Testing example:
```bash
$ telnet localhost 10143
Trying ::1...
Connected to localhost.
Escape character is '^]'.
* OK [CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS ID ENABLE IDLE AUTH=PLAIN AUTH=LOGIN] Dovecot ready.
a login dummy redhat
a OK [CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS ID ENABLE IDLE SORT SORT=DISPLAY THREAD=REFERENCES THREAD=REFS THREAD=ORDEREDSUBJECT MULTIAPPEND URL-PARTIAL CATENATE UNSELECT CHILDREN NAMESPACE UIDPLUS LIST-EXTENDED I18NLEVEL=1 CONDSTORE QRESYNC ESEARCH ESORT SEARCHRES WITHIN CONTEXT=SEARCH LIST-STATUS BINARY MOVE] Logged in
a logout
* BYE Logging out
a OK Logout completed (0.001 + 0.000 secs).
Connection closed by foreign host.
```
