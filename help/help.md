% DOVECOT(1) Container Image Pages
% Petr Hracek
% Oct 1, 2017

# NAME
{{ spec.envvars.name }} - {{ spec.short_description }}

# DESCRIPTION
{{ spec.short_description }}

The container itself consists of:
    - {{ config.docker.from }} base image
    - {{ spec.envvars.name }} RPM package

Files added to the container during docker build include: /files/start.sh

# USAGE
To get the {{ spec.envvars.name }} container image on your local system, run the following:

    docker pull {{ spec.image_repository }}
    
# VOLUMES

* /var/spool/postfix - contains directories for socket communication with Postfix.

* /var/spool/mail - contains directories for INBOXes.

# SEE ALSO
Dovecot page
<https://www.dovecot.org/>
