#!/usr/bin/env bash

DOVECOT_CONF="/etc/dovecot/dovecot.conf"

function modify_dovecot_conf() {
    update_dovecot_conf "mail_location" "mbox:~/mail:INBOX=/var/mail/%u"
    update_dovecot_conf "disable_plaintext_auth" "no"
    update_dovecot_conf "auth_mechanisms" "plain login"
    update_dovecot_conf "mail_privileged_group" "mail"
    update_dovecot_conf "auth_debug" "yes"
    update_dovecot_conf "auth_verbose" "yes"
    update_dovecot_conf "mail_debug" "yes"
    update_dovecot_conf "debug_log_path" "/var/dovecot/dovecot-debug.log"
    update_dovecot_conf "info_log_path" "/var/dovecot/dovecot-info.log"
    update_dovecot_conf "log_path" "/var/dovecot/dovecot.log"
    update_dovecot_conf "protocols" "imap"

    doveconf -n | grep "ssl"
    if [[ $? -eq 1 ]]; then
        echo "ssl = yes" >> /etc/dovecot/conf.d/10-ssl.conf
    else
        sed -i 's/^ssl\(\s*\)=\(\s*\).*/ssl\1=\2yes/g' /etc/dovecot/conf.d/10-ssl.conf
    fi
    doveconf -n | grep "service imap-login"
    if [[ $? -eq 1 ]]; then
        cat /files/dovecot_imap.conf >> /etc/dovecot/conf.d/10-master.conf
    fi
}

if [[ -f "/var/run/nologin" ]]; then
    rm -f /var/run/nologin
fi

DOVECOT_PKI="/etc/pki/dovecot"
if [[ ! -f "$DOVECOT_PKI/private/dovecot.pem" ]]; then
    SSLDIR=$DOVECOT_PKI OPENSSLCONFIG="$DOVECOT_PKI/dovecot-openssl.cnf" \
    /usr/libexec/dovecot/mkcert.sh /dev/null 2>&1
fi
if [[ ! -f "/var/lib/dovecot/ssl-parametrs.dat" ]]; then
    /usr/libexec/dovecot/ssl-params >/dev/null 2>&1
fi

if [[ -z ${MYHOSTNAME} ]]; then
    MYHOSTNAME=localhost
fi

source /files/common.sh

mkdir -p /var/certs
chown root:root /var/certs
mkdir -p /var/dovecot
chown root:root /var/dovecot

modify_dovecot_conf

dovecot -n
