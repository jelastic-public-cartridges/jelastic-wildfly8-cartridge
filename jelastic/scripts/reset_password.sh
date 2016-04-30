#!/bin/bash

source /etc/jelastic/environment;
export JAVA_HOME="/usr/java/default/";

#$J_OPENSHIFT_APP_ADM_USER        ;   Operate this variable for the username
#$J_OPENSHIFT_APP_ADM_PASSWORD    ;   Use this varible for your password

function _setPassword() {
        $OPENSHIFT_WILDFLY_DIR/versions/${Version}/bin/add-user.sh --user ${J_OPENSHIFT_APP_ADM_USER} --password ${J_OPENSHIFT_APP_ADM_PASSWORD} --silent --enable
}






