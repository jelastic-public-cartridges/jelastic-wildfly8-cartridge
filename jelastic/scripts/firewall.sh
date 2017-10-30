#!/bin/bash -eu

/sbin/iptables -t nat -I PREROUTING -p tcp -m tcp --dport 4949 -j REDIRECT --to-ports 9990;
/sbin/iptables -t nat -I PREROUTING -p tcp -m tcp --dport 4848 -j REDIRECT --to-ports 9993;
iptables -t nat -D PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8080
