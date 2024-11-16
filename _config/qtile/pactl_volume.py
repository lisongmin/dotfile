#!/usr/bin/env python3
from subprocess import check_output, call, list2cmdline
import json
from threading import Lock
from libqtile.widget.volume import Volume
from libqtile.widget.textbox import TextBox
from libqtile.command.base import expose_command
from libqtile.utils import send_notification


class PactlVolume(Volume):
    def __init__(self, percent_box: TextBox, **config):
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

        self.percent_box = percent_box

        self._current_sink = ""
        self._switch_sink_lock = Lock()

        self.mouse_callbacks = {
            "Button3": self.switch_sink,
        }
        super().__init__(**config)

    @property
    def default_sink(self) -> str:
        return "@DEFAULT_SINK@"

    @property
    def current_sink(self) -> str:
        if self._current_sink:
            return self._current_sink

        self._current_sink = check_output(
            ["pactl", "get-default-sink"], text=True
        ).strip()

        return self._current_sink

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

    def get_volume(self):
        vol, muted = super().get_volume()
        if vol != self.volume:
            self.percent_box.update(f"{vol or 0}%")

        return vol, muted

    def update_volume(self):
        vol, muted = self.get_volume()
        self.volume = vol

    @expose_command()
    def increase_vol(self):
        super().increase_vol()
        self.update_volume()

    @expose_command()
    def decrease_vol(self):
        super().decrease_vol()
        self.update_volume()

    @expose_command()
    def switch_sink(self):
        self.switch_to_next_sink()

    @expose_command()
    def switch_to_preferred_sink(self):
        output = check_output(["pactl", "-f", "json", "list", "sinks"], text=True)
        sinks = json.loads(output)
        if len(sinks) == 0:
            return

        sinks = sorted(sinks, key=lambda x: self.priority_of_sink(x))
        preferred_sink = sinks[0]

        with self._switch_sink_lock:
            self.set_sink(preferred_sink)

    def switch_to_next_sink(self):
        output = check_output(["pactl", "-f", "json", "list", "sinks"], text=True)
        sinks = json.loads(output)
        if len(sinks) < 2:
            return

        sinks = sorted(sinks, key=lambda x: x.get("index"))
        current_sink_index = -1
        for i, sink in enumerate(sinks):
            if sink["name"] == self.current_sink:
                current_sink_index = i
                break

        next_sink_index = (current_sink_index + 1) % len(sinks)
        next_sink = sinks[next_sink_index]

        with self._switch_sink_lock:
            self.set_sink(next_sink)

    def set_sink(self, sink: dict):
        name = sink["name"]
        if self.current_sink == name:
            return

        self._current_sink = name
        call(
            ["pactl", "set-default-sink", name],
            text=True,
        )

        self.update_volume()

        nick = sink["properties"]["node.nick"]
        send_notification(
            "Volume sink switched",
            f"The volume sink switched to {nick}",
            timeout=5000,
        )

    def priority_of_sink(self, sink: dict) -> int:
        _active_port = sink.get("active_port") or ""

        if "headphones" in _active_port:
            return 100
        elif "hdmi" in _active_port:
            return 200
        else:
            return 500
