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

    # check if "${JENKINS_REF}/plugins.txt" exists
    HAS_PLUGINS_TXT=$([ -f "${JENKINS_REF}/plugins.txt" ] && echo 1 || echo 0)

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

        # initialize plugins if HAS_PLUGINS_TXT is false
        if [ "$IS_DEVELOPMENT" == "true" ] && [ -f "$AUTOSETUP_TMP/plugins_dev.txt" ]; then
            echo "Setting up DEVELOPMENT Plugins - will be loaded on startup using the managePlugins.groovy"
            cat "$AUTOSETUP_TMP/plugins_dev.txt" >> "${JENKINS_REF}/plugins.txt"
            cat "$AUTOSETUP_TMP/plugins_dev.txt" | xargs /usr/local/bin/install-plugins.sh
        elif [ -f "$AUTOSETUP_TMP/plugins.txt" ] && [ $HAS_PLUGINS_TXT -eq 0 ]; then
            echo "Setting up Plugins - will be loaded on startup using the managePlugins.groovy"
            cat "$AUTOSETUP_TMP/plugins.txt" >> "${JENKINS_REF}/plugins.txt"
            cat "$AUTOSETUP_TMP/plugins.txt" | xargs /usr/local/bin/install-plugins.sh
        elif [ $HAS_PLUGINS_TXT -eq 1 ]; then
            echo "Plugins already set up, will not reinitialize"
        fi

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
