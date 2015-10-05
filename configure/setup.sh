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
exec $EAP_HOME/bin/openshift-launch.sh &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Executing the commands"
$JBOSS_CLI -c --file=/opt/eap/customization/configure/setup.cli

echo "SHUTDOWN JBoss EAP"
$JBOSS_CLI -c ":shutdown"