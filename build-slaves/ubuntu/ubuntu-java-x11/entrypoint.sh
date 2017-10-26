#!/bin/bash

set -e
set -u

# Supervisord default params
SUPERVISOR_PARAMS='-c /etc/supervisor/supervisord.conf'

# We have TTY, so probably an interactive container...
if test -t 0; then
  # Run supervisord detached...
  /usr/bin/supervisord $SUPERVISOR_PARAMS
  
  # Some command(s) has been passed to container? Execute them and exit.
  # No commands provided? Run bash.
  if [[ $@ ]]; then 
    eval $@
  else 
    export PS1='[\u@\h : \w]\$ '
    /bin/bash
  fi

# Detached mode? Run supervisord in foreground, which will stay until container is stopped.
else
  if [[ $@ ]]; then 
    /usr/bin/supervisord $SUPERVISOR_PARAMS
    eval $@
  else
    /usr/bin/supervisord -n $SUPERVISOR_PARAMS
  fi
fi
