if [ "$SSH_CONNECTION" ] && [ -z "$ENV_DONE" ]; then
pushd . >/dev/null

for __dir in \
/proc/registry/HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Session\ Manager/Environment \
/proc/registry/HKEY_CURRENT_USER/Environment
do
    for __var in `ls "$__dir"`
    do
        if [ ! -z "${__var}" ]; then
            __val=$(cat "$__dir/$__var" | xargs --null printf "%s" | sed 's/%(.*?)%)/$\\1/g')
            __var=$(echo "$__var" | sed 's/\(\W\)/_/g' | tr [a-z] [A-Z])
            [ ! -z "${__val}" ] && [ -z "${!__var}" ] && export ${__var}="${__val%\"}" && echo "Exported '${__var}'" || echo "SKIPPED: '${__var}'"
        fi
    done
done

export ENV_DONE=true
unset __dir
unset __var
popd >/dev/null
fi
