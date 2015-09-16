#!/bin/bash
EAP_HOME=/opt/eap
export EAP_HOME
echo "EAP HOME => $EAP_HOME"

JBOSS_CLI=$EAP_HOME/bin/jboss-cli.sh
export JBOSS_CLI
echo "JBOSS_CLI HOME => $JBOSS_CLI"

function wait_for_server() {
  until `$JBOSS_CLI -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 1
  done
}

echo "=> Starting JBoss EAP server"
#exec $EAP_HOME/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
#exec $EAP_HOME/bin/standalone.sh -c standalone-openshift.xml -b 0.0.0.0 -bmanagement 0.0.0.0
#$EAP_HOME/bin/standalone.sh -c standalone-openshift.xml -b 0.0.0.0 -bmanagement 0.0.0.0
exec $EAP_HOME/bin/openshift-launch.sh &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Executing the commands"
#$JBOSS_CLI -c --file=`dirname "$0"`/setup.cli
#$JBOSS_CLI -c run-batch --file=myscript.txt
$JBOSS_CLI -c --file=/opt/eap/customization/configure/setup.cli

echo "SHUTDOWN JBoss EAP"
$JBOSS_CLI -c ":shutdown"

#echo "=> Shutting down JBoss EAP server"
#if [ "$JBOSS_MODE" = "standalone" ]; then
 # $JBOSS_CLI -c ":shutdown"
## $JBOSS_CLI -c "/host=*:shutdown"


#echo "=> Restarting JBoss EAP server"
#exec $EAP_HOME/bin/standalone.sh -c standalone-openshift.xml -bmanagement 0.0.0.0
#exec $EAP_HOME/bin/openshift-launch.sh