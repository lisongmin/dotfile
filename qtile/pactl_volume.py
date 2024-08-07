#!/usr/bin/env python3
from subprocess import check_output, list2cmdline
import json
from libqtile.widget.volume import Volume
from libqtile.command.base import expose_command
from libqtile.utils import send_notification


class PactlVolume(Volume):
    def __init__(self, **config):
        for key in [
            "get_volume_command",
            "check_mute_command",
            "check_mute_string",
            "volume_up_command",
            "volume_down_command",
            "mute_command",
            "volume_app",
        ]:
            config.pop(key, None)

        self._current_sink = ""
        self.mouse_callbacks = {
            "Button3": self.switch_sink,
        }
        Volume.__init__(self, **config)

    @property
    def default_sink(self) -> str:
        return "@DEFAULT_SINK@"

    @property
    def get_volume_command(self):
        return list2cmdline(
            [
                "pactl",
                "get-sink-volume",
                self.default_sink,
            ]
        )

    @property
    def check_mute_command(self):
        return list2cmdline(
            [
                "pactl",
                "get-sink-mute",
                self.default_sink,
            ]
        )

    @property
    def check_mute_string(self):
        return "yes"

    @property
    def volume_up_command(self):
        return list2cmdline(
            [
                "pactl",
                "set-sink-volume",
                self.default_sink,
                "+{}%".format(self.step),
            ]
        )

    @property
    def volume_down_command(self):
        return list2cmdline(
            [
                "pactl",
                "set-sink-volume",
                self.default_sink,
                "-{}%".format(self.step),
            ]
        )

    @property
    def mute_command(self):
        return list2cmdline(
            [
                "pactl",
                "set-sink-mute",
                self.default_sink,
                "toggle",
            ]
        )

    @property
    def volume_app(self):
        return "qpwgraph"

    @expose_command()
    def switch_sink(self):
        self.switch_to_preferred_sink()

    def switch_to_preferred_sink(self):
        output = check_output(["pactl", "-f", "json", "list", "sinks"], text=True)
        sinks = json.loads(output)
        if len(sinks) == 0:
            return

        sinks = sorted(sinks, key=lambda x: self.priority_of_sink(x))
        preferred_sink = sinks[0]
        name = preferred_sink["name"]
        if self._current_sink == name:
            return

        check_output(
            ["pactl", "set-default-sink", name],
            text=True,
        )
        self._current_sink = name

        nick = preferred_sink["properties"]["node.nick"]
        send_notification(
            "Volume sink switched",
            f"The volume sink switched to {nick}",
            timeout=5000,
        )

    def priority_of_sink(self, sink: dict) -> int:
        if "headphones" in sink["active_port"]:
            return 100
        elif "hdmi" in sink["active_port"]:
            return 200
        else:
            return 500
