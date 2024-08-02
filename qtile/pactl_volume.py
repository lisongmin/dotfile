#!/usr/bin/env python3
from subprocess import check_output, list2cmdline
from libqtile.widget.volume import Volume


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

        self._default_sink = ""

        Volume.__init__(self, **config)

    @property
    def default_sink(self) -> str:
        if not self._default_sink:
            try:
                stdout = check_output(["pactl", "get-default-sink"], text=True)
                self._default_sink = stdout.strip()
            except Exception:
                pass

        return self._default_sink

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
