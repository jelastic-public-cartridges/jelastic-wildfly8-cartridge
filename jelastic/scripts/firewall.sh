#!/bin/bash -eu

/sbin/iptables -t nat -I PREROUTING -p tcp -m tcp --dport 4949 -j REDIRECT --to-ports 9990;
/sbin/iptables -t nat -I PREROUTING -p tcp -m tcp --dport 4848 -j REDIRECT --to-ports 9993;
/sbin/iptables -t nat -I PREROUTING -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 8443
