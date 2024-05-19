#!/bin/bash -e

export JAVA_OPTS='--add-opens java.base/java.net=ALL-UNNAMED --add-opens java.base/java.lang.invoke=ALL-UNNAMED'

# Path to the initialization marker file
INIT_MARKER_FILE="/var/gerrit/.initialized"

# Check if the initialization marker file exists
if [ ! -f "$INIT_MARKER_FILE" ]; then
  echo "First time initialization - downloading Gerrit OAuth plugin"
  
  # Run the initialization command
  curl -L https://github.com/davido/gerrit-oauth-provider/releases/download/v3.5.1/gerrit-oauth-provider.jar --output /var/gerrit/plugins/gerrit-oauth-provider.jar
  curl -L https://archive-ci.gerritforge.com/job/plugin-saml-bazel-master-stable-3.5/artifact/bazel-bin/plugins/saml/saml.jar --output /var/gerrit/lib/saml.jar
  # Create the marker file
  touch "$INIT_MARKER_FILE"
else
  echo "Gerrit already initialized - skipping download"
fi

if [ ! -d /var/gerrit/git/All-Projects.git ] || [ "$1" == "init" ]
then
  echo "Initializing Gerrit site ..."
  java $JAVA_OPTS -jar /var/gerrit/bin/gerrit.war init --batch --install-all-plugins -d /var/gerrit
  java $JAVA_OPTS -jar /var/gerrit/bin/gerrit.war reindex -d /var/gerrit
  git config -f /var/gerrit/etc/gerrit.config --add container.javaOptions "-Djava.security.egd=file:/dev/./urandom"
  git config -f /var/gerrit/etc/gerrit.config --add container.javaOptions "--add-opens java.base/java.net=ALL-UNNAMED"
  git config -f /var/gerrit/etc/gerrit.config --add container.javaOptions "--add-opens java.base/java.lang.invoke=ALL-UNNAMED"
fi

git config -f /var/gerrit/etc/gerrit.config gerrit.canonicalWebUrl "${CANONICAL_WEB_URL:-http://$HOSTNAME/}"
if [ ${HTTPD_LISTEN_URL} ];
then
  git config -f /var/gerrit/etc/gerrit.config httpd.listenUrl ${HTTPD_LISTEN_URL}
fi

if [ "$1" != "init" ]
then
  echo "Running Gerrit ..."
  exec /var/gerrit/bin/gerrit.sh run
fi
