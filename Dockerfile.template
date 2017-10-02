FROM {{ config.docker.registry }}/{{ config.docker.from }}

ENV VERSION={{ spec.envvars.version }} \
    RELEASE={{ spec.envvars.release }} \
    NAME={{ spec.envvars.name }} \
    ARCH={{ spec.envvars.arch }}
LABEL maintainer {{ spec.maintainer }}
LABEL   summary="{{ spec.short_description }}" \
        name="$FGC/$NAME" \
        version="$VERSION" \
        release="$RELEASE.$DISTTAG" \
        architecture="$ARCH" \
        com.redhat.component="$NAME" \
        usage="{{ spec.envvars.name }} run -it -e MYHOSTNAME=localhost -v /etc/dovecot:/etc/dovecot dovecot" \
        help="Runs {{ spec.envvars.name }}. No dependencies. See Help File below for more details." \
        description="{{ spec.short_description }}" \
        io.k8s.description="{{ spec.short_description }}" \
        io.k8s.diplay-name="3.1" \
        io.openshift.tags="{{ spec.envvars.name }}"

RUN {{ commands.pkginstaller.install(["openssl-libs", "dovecot"])}} && \
    {{ commands.pkginstaller.cleancache()}}

ADD files /files
ADD README.md /

RUN /files/dovecot_config.sh

VOLUME ["/var/spool/postfix"]
VOLUME ["/var/spool/mail"]
VOLUME ["/var/dovecot"]

CMD ["/files/start.sh"]
