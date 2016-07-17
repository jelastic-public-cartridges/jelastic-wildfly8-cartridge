if [ "x$JBOSS_MODULES_SYSTEM_PKGS" = "x" ]; then
   JBOSS_MODULES_SYSTEM_PKGS="org.jboss.byteman,org.jboss.logmanager"
fi
source /etc/jelastic/environment;
source $OPENSHIFT_CARTRIDGE_SDK_BASH

if [ -e /opt/repo/versions/${Version}/bin/variablesparser.sh ]; then
      . /opt/repo/versions/${Version}/bin/variablesparser.sh
fi

JAVA_OPTS="${JAVA_OPTS} -DOPENSHIFT_APP_UUID=${OPENSHIFT_APP_UUID} -Xbootclasspath/p:/opt/repo/versions/${Version}/modules/system/layers/base/org/jboss/logmanager/main/jboss-logmanager-1.5.2.Final.jar -Djava.util.logging.manager=org.jboss.logmanager.LogManager -Dorg.jboss.resolver.warning=true -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8 -Djboss.node.name=$(hostname) -Djgroups.bind_addr=${OPENSHIFT_JBOSSAS_IP} -Dorg.apache.coyote.http11.Http11Protocol.COMPRESSION=on"

if [ ! -z "$ENABLE_JPDA" ]; then
   JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=${OPENSHIFT_WILDFLY_IP}:8787,server=y,suspend=n ${JAVA_OPTS}"
fi

JAVA_OPTS="$JAVA_OPTS -Djboss.modules.system.pkgs=$JBOSS_MODULES_SYSTEM_PKGS -Djava.awt.headless=true"
