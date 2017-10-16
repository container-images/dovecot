#!/usr/bin/env bash

SERVICES="/etc/services"
MASTER="/etc/postfix/master.cf"

update_dovecot_conf() {
    option=$1
    value=$2
    file_name="/etc/dovecot/dovecot.conf"
    doveconf -n | grep "^$option"
    if [[ $? -eq 1 ]]; then
        echo "$option = $value" >> $file_name
    fi
}

