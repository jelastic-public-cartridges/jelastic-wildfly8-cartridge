#!/bin/bash

echo -e "$(find $(realpath /usr/java/latest) -name libjli.so -printf "%h\n")" > /etc/ld.so.conf.d/java.conf ; \
ldconfig

