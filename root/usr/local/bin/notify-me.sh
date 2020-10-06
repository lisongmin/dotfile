#!/usr/bin/env bash

send-via-dbus()
{
    local display=:0

    local current_user
    local user_id

    current_user=$(who|grep -i "(${display})"|awk '{print $1}')
    user_id=$(id -u ${current_user})
    if [ "$(id -u)" = "$user_id" ]; then
        export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${user_id}/bus
        notify-send "${@}"
    else
        su - ${current_user} << EOF
            export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${user_id}/bus
            notify-send $(printf "%q " "${@}")
EOF
    fi
}

notify()
{
    local event="$1"
    local extra_args="${@:2}"

    case "$event" in
        low_power)
            local capacity="${extra_args[0]}"
            send-via-dbus -u 'critical' -c 'battery::low-power' 'Low power' "The power of battery is ${capacity}% only"
            ;;
    esac
}

notify "$@"
