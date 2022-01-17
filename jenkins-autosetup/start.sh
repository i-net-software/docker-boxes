#!/bin/bash

AUTOSETUP_TMP=/tmp/autosetup
JENKINS_REF=/usr/share/jenkins/ref/
JENKINS_PLUGINS_URL=https://get.jenkins.io/plugins

export TINI_SUBREAPER=1
export ATTEMPTS=${ATTEMPTS-1}

# Installing the plugins requires a preflight check because 
function installPlugins {
    local pluginsFile=$1
    local tmpPluginFile=$(mktemp --suffix=.txt)
    
    if [ -f $pluginsFile ]; then
        echo "Installing plugins from $pluginsFile"
        while read plugin; do
            if [ -n "$plugin" ]; then
                # split at colon
                pluginName=$(echo $plugin | cut -d: -f1)
                # split at colon, second part
                pluginVersion=$(echo $plugin | cut -d: -f2)
                pluginVersion=${pluginVersion:-latest}
                if ${UPDATE_JENKINS:-false}; then
                    actualVersion=latest
                else
                    actualVersion=$(curl -fsSL "$JENKINS_PLUGINS_URL/${pluginName}" | grep "\"${pluginVersion}" | awk -F\" '{print $2}' | head -n 1 | cut -d/ -f1)
                fi
                # list https://get.jenkins.io/plugins/$pluginName for version
                echo "Installing plugin $pluginName version $actualVersion"
                actualVersion=${actualVersion:-$pluginVersion}
                echo "Plugin ${pluginName}: ${actualVersion} (requested: ${pluginVersion})"
                echo "${pluginName}:${actualVersion}" >> "${tmpPluginFile}"
            fi
        done < $pluginsFile
    else
        echo "File $pluginsFile does not exist"
    fi

    jenkins-plugin-cli --plugin-file "${tmpPluginFile}"
    rm -f "${tmpPluginFile}"
}

######################################################################
# Check for a configuration URL for startup
# Can be svn:// or git://
# e.g.
# export AUTOSETUP="svn://<url>/<path> https://github.com/<path>.git"
#
if [ ! -z "$AUTOSETUP" ]; then

    # check if "${JENKINS_REF}/plugins.txt" exists
    HAS_PLUGINS_TXT=$([ -f "${JENKINS_REF}/plugins.txt" ] && echo 1 || echo 0)
    if [ $HAS_PLUGINS_TXT -eq 1 ] && [ "$IS_DEVELOPMENT" == "true" ]; then
        echo "WARNING: You are running in development mode and have plugins.txt in your jenkins ref folder. Will remove it now."
        rm -f "${JENKINS_REF}/plugins.txt"
    fi

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
            installPlugins "$AUTOSETUP_TMP/plugins_dev.txt"
        elif [ -f "$AUTOSETUP_TMP/plugins.txt" ] && [ $HAS_PLUGINS_TXT -eq 0 ]; then
            echo "Setting up Plugins - will be loaded on startup using the managePlugins.groovy"
            cat "$AUTOSETUP_TMP/plugins.txt" >> "${JENKINS_REF}/plugins.txt"
            installPlugins "$AUTOSETUP_TMP/plugins.txt"
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
