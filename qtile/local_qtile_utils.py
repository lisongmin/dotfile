#!/usr/bin/env python

import os
import shutil
import logging
import subprocess
from libqtile.widget.battery import Battery, BatteryState, BatteryStatus


def first_of_excutable(candidates: list, abs_path=False) -> str | None:
    for candidate in candidates:
        path = shutil.which(candidate)
        if path:
            return path if abs_path else candidate

    logging.warning(f"No excutable found in list [{candidates}]")
    return None


def first_of_sensor_tag(candidates: list) -> str | None:
    p = subprocess.Popen(['sensors'], stdout=subprocess.PIPE)
    out, _ = p.communicate()
    out = out.decode()
    for tag in candidates:
        if tag in out:
            return tag

    return None


def first_of_net(candidates: list) -> str | None:
    nets = os.listdir('/sys/class/net')

    for candidate in candidates:
        for net in nets:
            if net.startswith(candidate):
                return net

    return None


def first_of_wire_net() -> str | None:
    return first_of_net(['br', 'bridge', 'bond', 'en', 'eth'])


def first_of_wireless_net() -> str | None:
    return first_of_net(['wl'])


class BatteryNerdIcon(Battery):

    # symbol from ttf-nerd-fonts-symbols
    DISCHARGING_ICONS = {
        0: "\U000f008e",  # 0%
        1: "\U000f007a",  # 10%
        2: "\U000f007b",  # 20%
        3: "\U000f007c",  # 30%
        4: "\U000f007d",  # 40%
        5: "\U000f007e",  # 50%
        6: "\U000f007f",  # 60%
        7: "\U000f0080",  # 70%
        8: "\U000f0081",  # 80%
        9: "\U000f0082",  # 90%
        10: "\U000f0079",  # 100%
        }

    CHARGING_ICONS = {
        0: "\U000f089f",  # 0%
        1: "\U000f089c",  # 10%
        2: "\U000f0086",  # 20%
        3: "\U000f0087",  # 30%
        4: "\U000f0088",  # 40%
        5: "\U000f089d",  # 50%
        6: "\U000f0089",  # 60%
        7: "\U000f089e",  # 70%
        8: "\U000f008a",  # 80%
        9: "\U000f008b",  # 90%
        10: "\U000f0085",  # 100%
        }

    UNKNOWN_ICON = "\U000f0091"
    FULL_ICON = "\U000f0079"
    LOW_POWER_ALERT_ICON = "\U000f0083"

    def build_string(self, status: BatteryStatus) -> str:
        char = self.UNKNOWN_ICON
        if status.state == BatteryState.CHARGING:
            char = self.CHARGING_ICONS.get(int(status.percent * 10), char)
        elif status.state == BatteryState.DISCHARGING:
            char = self.DISCHARGING_ICONS.get(int(status.percent * 10), char)
        elif status.state == BatteryState.FULL:
            char = self.FULL_ICON

        if self.layout is not None:
            if status.state == BatteryState.DISCHARGING \
                    and self.low_percentage is not None \
                    and status.percent < self.low_percentage:
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
