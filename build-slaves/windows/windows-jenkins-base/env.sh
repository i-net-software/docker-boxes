if [ "$SSH_TTY" ]; then
pushd . >/dev/null
for __dir in \
/proc/registry/HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Session\ Manager/Environment \
/proc/registry/HKEY_CURRENT_USER/Environment
do
    cd "$__dir"
    for __var in *
    do
        __var=`echo $__var | tr '[a-z]' '[A-Z]'`
        test -z "${!__var}" && export $__var="`cat $__var`" >/dev/null 2>&1
    done
done
unset __dir
unset __var
popd >/dev/null
fi
