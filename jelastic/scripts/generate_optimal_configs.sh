#!/bin/bash

echo -e "$(find $(realpath /usr/java/latest) -name libjli.so -printf "%h\n")" > /etc/ld.so.conf.d/java.conf ; \
ldconfig

JAVABIN=$(which java 2>/dev/null)
[ ! -z "$JAVABIN" ] && {
    setcap 'cap_net_bind_service=+ep' $(readlink -f "$JAVABIN")
}

/sbin/service iptables restart &>/dev/null
