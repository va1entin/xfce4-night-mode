#!/bin/bash
# XFCE Night Mode controlled by Redshift
#
# https://github.com/bimlas/xfce4-night-mode (please star if you like the plugin)

# Change this variable to define which mode to use while RedShift transitions from day to night or vice versa
# Choices: night|day

# Print XML for genmon plugin
set_mode() {
  "$(dirname "$0")/xfce4-night-mode.sh" "$mode" | sed '/<tool>/,/<\/tool>/ d'
  echo '<tool>
    Night mode defined by RedShift
    Click to toggle mode for a while
  </tool>'
  exit 0
}

# exit if override file exists to stay on current theme
# for example if user changed it manually via UI and doesn't want it changed regardless of RedShift
if [ -f /tmp/xfce4-night-mode.lock ]; then
  set_mode
fi

TRANSITION_MODE='night'

redshift_period=$( LC_ALL='C' redshift -p 2> /dev/null | grep -E '^Period: ' | grep -Eo '(Transition|Night|Day)' )

case $redshift_period in
  "Day")
    mode='day'
    ;;

  "Night")
    mode='night'
    ;;

  "Transition")
    if [ $TRANSITION_MODE ]; then
      if [[ $TRANSITION_MODE =~ (day|night) ]]; then
        mode=$TRANSITION_MODE
      else
        echo 'Invalid value set for $TRANSITION_MODE!'
      fi
    else
      echo 'RedShift transition period detected but $TRANSITION_MODE is not set. Set $TRANSITION_MODE to define which mode to use during transition periods.'
    fi
    ;;

  *)
    echo "Could not determine RedShift period: $redshift_period"
    ;;
esac

set_mode