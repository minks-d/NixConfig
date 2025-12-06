while [[ $(tuned-adm active) != *$NIXOS_TUNED_PROFILE* ]]
do
    echo "$(tuned-adm active), not $NIXOS_TUNED_PROFILE"
    dbus-send --system --dest=com.redhat.tuned --type=method_call --print-reply "/Tuned" com.redhat.tuned.control.switch_profile string:"${config.services.tuned.activeProfile}"
    sleep 15
done
