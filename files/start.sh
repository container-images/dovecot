#!/bin/bash

if [[ ! -z "${DEBUG_MODE}" ]]; then
    rpm -q syslog-ng
    if [[ $? -ne 0 ]]; then
        dnf -y --setopt=tsflags=nodocs install syslog-ng && \
        dnf -y clean all
        syslog-ng
    fi
fi


dovecot

while true; do
    dovecot_pid=$(cat /var/run/dovecot/master.pid)
	if [[ ! -d "/proc/$PID" ]]; then
	    echo "Dovecot process $dovecot_pid does not exist."
	    break
	fi
	sleep 10
done
