#!/bin/bash

AUTOSETUP_TMP=/tmp/autosetup
JENKINS_REF=/usr/share/jenkins/ref/
export TINI_SUBREAPER=1
export ATTEMPTS=${ATTEMPTS-1}

######################################################################
# Check for a configuration URL for startup
# Can be svn:// or git://
# e.g.
# export AUTOSETUP="svn://<url>/<path> https://github.com/<path>.git"
#
if [ ! -z "$AUTOSETUP" ]; then

    for SETUP in ${AUTOSETUP[@]}; do
        if [ -d "$AUTOSETUP_TMP" ]; then
            rm -rf "$AUTOSETUP_TMP"
        fi

        EXTS=( ${SETUP:0:3} ${AUTOSETUP:${#SETUP}<3?0:-3} )
        for EXT in ${EXTS[@]}; do
            case $EXT in
                git )
                    git clone --depth=1 --quiet "$SETUP" "$AUTOSETUP_TMP"
                    break
                    ;;
                svn )
                    USER=${SETUP#*//}
                    USER=${USER%@*}

                    if [ ! -z "$USER" ]; then
                        PASSWORD=${USER#*:}
                        USER=${USER%:*}
                        svn export --username="$USER" --password="$PASSWORD" "$SETUP" "$AUTOSETUP_TMP"
                    else
                        svn export "$SETUP" "$AUTOSETUP_TMP"
                    fi

                    break
                    ;;
            esac
        done

        # initializep plugins
        if [ "$IS_DEVELOPMENT" == "true" ] && [ -f "$AUTOSETUP_TMP/plugins_dev.txt" ]; then
            echo "Setting up DEVELOPMENT Plugins - will be loaded on startup using the managePlugins.groovy"
            cp "$AUTOSETUP_TMP/plugins_dev.txt" "${JENKINS_REF}/plugins.txt"
        elif [ -f "$AUTOSETUP_TMP/plugins.txt" ]; then
            echo "Setting up Plugins - will be loaded on startup using the managePlugins.groovy"
            cp "$AUTOSETUP_TMP/plugins.txt" "${JENKINS_REF}"
        fi

        # install plugins
        jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt || exit 1

        if [ -d "$AUTOSETUP_TMP/config" ]; then
            echo "Copying configuration files"
            mkdir -p "${JENKINS_REF}init.groovy.d/"
            find "$AUTOSETUP_TMP/config" -name "*.groovy" -exec cp -v {} "${JENKINS_REF}init.groovy.d/" \;
            find "$AUTOSETUP_TMP/config" -name "*.xml" -exec cp -v {} "${JENKINS_REF}" \;

            # Override functions
            find "$AUTOSETUP_TMP/config" -name "*.groovy.override" -exec cp -v {} "${JENKINS_REF}init.groovy.d/" \;
            find "$AUTOSETUP_TMP/config" -name "*.xml.override" -exec cp -v {} "${JENKINS_REF}" \;
        fi

        if [ -d "$AUTOSETUP_TMP/jobs" ]; then
            echo "Copying job files"
            mkdir -p "${JENKINS_REF}jobs/"
            find "$AUTOSETUP_TMP/jobs" -name "*.xml" -exec cp -v {} "${JENKINS_REF}jobs/" \;
        fi
    done
    rm -rf "$AUTOSETUP_TMP"
fi

######################################################################

/sbin/tini -- /usr/local/bin/jenkins.sh $*
