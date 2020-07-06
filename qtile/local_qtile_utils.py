#!/usr/bin/env python

import os
import shutil
import logging
import subprocess
from libqtile.widget.battery import Battery, BatteryState, BatteryStatus


def first_of_excutable(candidates: list, abs_path=False) -> str:
    for candidate in candidates:
        path = shutil.which(candidate)
        if path:
            return path if abs_path else candidate

    logging.warning(f"No excutable found in list [{candidates}]")
    return None


def first_of_sensor_tag(candidates: list) -> str:
    p = subprocess.Popen(['sensors'], stdout=subprocess.PIPE)
    out, dummy_err = p.communicate()
    out = out.decode()
    for tag in candidates:
        if tag in out:
            return tag

    return None


def first_of_net(candidates: list) -> str:
    nets = os.listdir('/sys/class/net')

    for candidate in candidates:
        for net in nets:
            if net.startswith(candidate):
                return net

    return None


def first_of_wire_net() -> str:
    return first_of_net(['br', 'bridge', 'bond', 'en', 'eth'])


def first_of_wireless_net() -> str:
    return first_of_net(['wl'])


class BatteryNerdIcon(Battery):

    # symbol from ttf-nerd-fonts-symbols
    DISCHARGING_ICONS = {
        0: "\uf582",  # alert on < 10%
        1: "\uf579",  # 10% ~ 20%
        2: "\uf57a",  # 20% ~ 30%
        3: "\uf57b",  # 30% ~ 40%
        4: "\uf57c",  # 40% ~ 50%
        5: "\uf57d",  # 50% ~ 60%
        6: "\uf57e",  # 60% ~ 70%
        7: "\uf57f",  # 70% ~ 80%
        8: "\uf580",  # 80% ~ 90%
        9: "\uf581",  # 90% ~ 99%
        10: "\uf578",  # 100%
        }

    CHARGING_ICONS = {
        0: "\uf585",  # alert on < 10%
        1: "\uf585",  # 10% ~ 20%
        2: "\uf586",  # 20% ~ 30%
        3: "\uf586",  # 20% ~ 30%
        4: "\uf587",  # 30% ~ 40%
        5: "\uf588",  # 40% ~ 50%
        6: "\uf588",  # 50% ~ 60%
        7: "\uf589",  # 60% ~ 70%
        8: "\uf589",  # 70% ~ 80%
        9: "\uf58a",  # 90% ~ 99%
        10: "\uf584",  # 100%
        }

    UNKNOWN_ICON = "\uf590"
    FULL_ICON = "\uf584"
    LOW_POWER_ALERT_ICON = "\uf582"

    def build_string(self, status: BatteryStatus) -> str:
        char = self.UNKNOWN_ICON
        if status.state == BatteryState.CHARGING:
            char = self.CHARGING_ICONS.get(int(status.percent * 10), char)
        elif status.state == BatteryState.DISCHARGING:
            char = self.DISCHARGING_ICONS.get(int(status.percent * 10), char)
        elif status.state == BatteryState.FULL:
            char = self.FULL_ICON

        if self.layout is not None:
            if status.state == BatteryState.DISCHARGING and status.percent < self.low_percentage:
                self.layout.colour = self.low_foreground
                char = self.LOW_POWER_ALERT_ICON
            else:
                self.layout.colour = self.foreground

        hour = status.time // 3600
        minute = (status.time // 60) % 60

        return self.format.format(
            char=char,
            percent=status.percent,
            watt=status.power,
            hour=hour,
            min=minute
        )
