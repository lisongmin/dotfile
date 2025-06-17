#!/usr/bin/env python3

from libqtile.backend.wayland import InputConfig  # type: ignore[import]

keyboard_layout = "us"
keyboard_options = ""

wl_input_rules = {
    "*": InputConfig(
        kb_layout=keyboard_layout,
        kb_options=keyboard_options,
        tap=True,
        natural_scroll=True,
    ),
}
