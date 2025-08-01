# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import re
import subprocess
import logging
import shutil
from pathlib import Path
from libqtile import qtile
from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.lazy import lazy
from libqtile import bar
from libqtile import hook
from libqtile.layout.stack import Stack
from libqtile.layout.max import Max
from libqtile.layout.xmonad import MonadTall
from libqtile.layout.floating import Floating
from libqtile.widget.textbox import TextBox
from libqtile.widget.net import Net
from libqtile.widget.groupbox import GroupBox
from libqtile.widget.prompt import Prompt
from libqtile.widget.windowname import WindowName
from libqtile.widget.systray import Systray
from libqtile.widget.graph import CPUGraph
from libqtile.widget.sensors import ThermalSensor
from libqtile.widget.clock import Clock
from libqtile.widget.do_not_disturb import DoNotDisturb
from libqtile.widget.battery import Battery
from local_qtile_utils import (
    first_exists,
    first_of_excutable,
    first_of_sensor_tag,
    first_of_wire_net,
    first_of_wireless_net,
    BatteryNerdIcon,
    WeekDay,
)
from pactl_volume import PactlVolume

if qtile.core.name == "wayland":
    from wayland import wl_input_rules

TOOLBAR_WIDTH = 32
TOOLBAR_ICON_SIZE = 22
TOOLBAR_DEFAULT_FONT_SIZE = 18
TOOLBAR_TEXT_FONT_SIZE = 14
TOOLBAR_DOUBLE_LINE_FONT_SIZE = 11

default_terminal = first_of_excutable(["kitty", "alacritty"])
default_file_manager = first_of_excutable(["nemo", "nautilus", "dolphin"])
default_fcitx = first_of_excutable(["fcitx5", "fcitx"])
sensor_tag = first_of_sensor_tag(["Tdie", "Core 0", "Tctl"])
wallpaper = first_exists(
    ["~/dotfile/wallpaper/family.jpeg", "~/dotfile/wallpaper/jzbq.jpeg"]
)

volume = PactlVolume(
    TextBox(fontsize=TOOLBAR_TEXT_FONT_SIZE, pedding=0),
    emoji=True,
    step=4,
    update_interval=1,
    fontsize=TOOLBAR_ICON_SIZE,
)

MOD = "mod4"

keys = [
    # Switch between windows in current stack pane
    Key([MOD], "j", lazy.layout.down()),
    Key([MOD], "k", lazy.layout.up()),
    # Key([MOD], "h", lazy.layout.grow()),
    # Key([MOD], "l", lazy.layout.shrink()),
    Key([MOD], "n", lazy.layout.next()),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down()),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up()),
    Key([MOD], "space", lazy.next_layout()),
    Key([MOD], "t", lazy.window.toggle_floating()),
    # 'win + w' switch to next screen
    Key([MOD], "w", lazy.next_screen()),
    Key([MOD, "shift"], "c", lazy.window.kill()),
    # 'win + q' reload qtile config
    Key([MOD], "q", lazy.restart()),
    # 'win + shift + q' logout
    Key([MOD, "shift"], "q", lazy.spawn("loginctl kill-session self")),
    # 'ctrl + alt + l' to  lock screan
    Key(["control", "mod1"], "l", lazy.spawn("loginctl lock-session")),
    # take a sreenshot
    Key([], "Print", lazy.spawn("flameshot gui -d 1")),
    # take a full screanshot and save to file
    Key(["shift"], "Print", lazy.spawn("flameshot full")),
    # take a full screanshot to clipboard
    Key(["control", "shift"], "Print", lazy.spawn("flameshot full -c")),
    Key([MOD], "Return", lazy.spawn(default_terminal)),
    Key([MOD, "mod1"], "r", lazy.spawn(f"{default_fcitx} -r -d")),
    Key([MOD, "mod1"], "w", lazy.spawn("firefox")),
    Key([MOD, "mod1"], "f", lazy.spawn(default_file_manager)),
    Key([MOD, "mod1"], "m", lazy.spawn("thunderbird")),
    Key([], "XF86AudioLowerVolume", lazy.function(lambda _: volume.decrease_vol())),
    Key([], "XF86AudioRaiseVolume", lazy.function(lambda _: volume.increase_vol())),
    Key([], "XF86AudioMute", lazy.function(lambda _: volume.mute())),
    Key([], "XF86AudioPlay", lazy.spawn("xmms2 toggle")),
    Key([], "XF86AudioStop", lazy.spawn("xmms2 stop")),
    Key([], "XF86AudioPrev", lazy.spawn("xmms2 prev")),
    Key([], "XF86AudioNext", lazy.spawn("xmms2 next")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 10%-")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s 10%+")),
    # TODO toogle the display
    # Key([], "XF86Display", lazy.spawn("autorandr -c")),
]

# 'alt + F2' or 'win + r' to run command
keys.append(Key(["mod1"], "F2", lazy.spawncmd()))
keys.append(Key([MOD], "r", lazy.spawncmd()))

groups = [
    Group("a", label="\ue7c5"),
    Group(
        "s",
        label="\U000f0239",
        matches=[Match(wm_class=re.compile(r"^(firefox|Chromium)$"))],
    ),
    Group("d", label="\ue795", matches=[Match(wm_class="Alacritty")]),
    Group(
        "f",
        label="\ue7b8",
        matches=[Match(wm_class=re.compile(r"^(dia|metasync)$"))],
    ),
    Group(
        "g",
        label="\ue217",
        matches=[Match(wm_class=re.compile(r"^(Telegram|Element)"))],
        layouts=[Stack(margin=1)],
    ),
    Group(
        "h",
        label="\U000f01ee",
        matches=[Match(wm_class=re.compile(r"^(Mail|thunderbird)$"))],
    ),
    Group("u", label="\ue287", matches=[Match(wm_class="Logseq")]),
    Group("i", label="\U000f05b3", matches=[Match(wm_class="virt-viewer")]),
]

for i in groups:
    # mod1 + letter of group = switch to group
    keys.append(Key([MOD], i.name, lazy.group[i.name].toscreen()))

    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(Key([MOD, "shift"], i.name, lazy.window.togroup(i.name)))

layouts = [Max(), MonadTall()]

widget_defaults = dict(
    fontsize=TOOLBAR_DEFAULT_FONT_SIZE,
    padding=4,
)


widgets = [
    TextBox("\uf303"),
    GroupBox(),
    Prompt(prompt="\uf120 "),
    TextBox(" \uf02c "),
    WindowName(fontsize=TOOLBAR_TEXT_FONT_SIZE),
]

if qtile.core.name == "x11":
    widgets.append(Systray())

widgets.extend(
    [
        CPUGraph(frequency=2),
    ]
)

if sensor_tag:
    widgets.extend(
        [
            TextBox(
                "\uef2b",
                fontsize=TOOLBAR_ICON_SIZE,
            ),
            ThermalSensor(
                tag_sensor=sensor_tag,
                fontsize=TOOLBAR_TEXT_FONT_SIZE,
            ),
        ]
    )


net_format = (
    "{up:6.2f}{up_suffix:<2} \U0000f062\n{down:6.2f}{down_suffix:<2} \U0000f063"
)
eth = first_of_wire_net()
if eth:
    widgets.extend(
        [
            TextBox(
                "\U000f0200",
                fontsize=TOOLBAR_ICON_SIZE,
            ),
            Net(
                interface=eth,
                format=net_format,
                fontsize=TOOLBAR_DOUBLE_LINE_FONT_SIZE,
                update_interval=2,
            ),
        ]
    )

wlan = first_of_wireless_net()
if wlan:
    widgets.extend(
        [
            TextBox(
                "\uf1eb",
                fontsize=TOOLBAR_ICON_SIZE,
            ),
            Net(
                interface=wlan,
                format=net_format,
                fontsize=TOOLBAR_DOUBLE_LINE_FONT_SIZE,
                update_interval=2,
            ),
        ]
    )

widgets.extend(
    [
        volume,
        volume.percent_box,
    ]
)

battery_path = Path("/sys/class/power_supply/BAT0")
battery_status_file = battery_path / "status"
if battery_path.exists():
    widgets.extend(
        [
            BatteryNerdIcon(
                format="{char}",
                fontsize=TOOLBAR_ICON_SIZE,
            ),
            Battery(
                format="{percent:2.0%}\n{hour:02}:{min:02}",
                fontsize=TOOLBAR_DOUBLE_LINE_FONT_SIZE,
                notify_below=10,
                notification_timeout=15,
            ),
        ]
    )

if qtile.core.name == "x11":
    # Do not disturb
    widgets.extend(
        [
            DoNotDisturb(
                fontsize=TOOLBAR_ICON_SIZE,
                update_interval=1,
                enabled_icon="\U000f116e",
                disabled_icon="\U000f0361",
            ),
        ]
    )

# Calendar and datetime
widgets.extend(
    [
        TextBox(
            text="\U000f00f0",
            fontsize=TOOLBAR_ICON_SIZE,
        ),
        WeekDay(
            update_interval=60,
            fontsize=TOOLBAR_ICON_SIZE,
        ),
        Clock(
            format="%m-%d\n%H:%M",
            fontsize=TOOLBAR_DOUBLE_LINE_FONT_SIZE,
        ),
    ]
)

top = bar.Bar(widgets, TOOLBAR_WIDTH, opacity=0.7)

screens = [
    Screen(top=top, wallpaper=wallpaper, wallpaper_mode="stretch"),
    Screen(wallpaper=wallpaper, wallpaper_mode="stretch"),
]

# Drag floating layouts.
mouse = [
    Drag(
        [MOD],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [MOD], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([MOD], "Button2", lazy.window.bring_to_front()),
]

# pylint: disable=invalid-name
# Disable warning for it is interface to qtile.

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = Floating(
    [
        Match(wm_class="flameshot"),
    ]
)

auto_fullscreen = True

log_level = logging.DEBUG

wmname = "Qtile"


@hook.subscribe.startup_once
def autostart():
    home = Path("~").expanduser()
    auto_start_script = home / ".config/qtile/autostart.sh"
    auto_start_log = home / ".local/share/qtile/autostart.log"

    if auto_start_log.exists():
        # backup auto_start_log before running the script
        backup_file = auto_start_log.with_suffix(".log.old")
        shutil.move(auto_start_log, backup_file)

    with open(auto_start_log, "w") as log_file:
        subprocess.Popen(["bash", auto_start_script], stdout=log_file, stderr=log_file)


@hook.subscribe.screen_change
def change_sink(ev):
    volume.switch_to_preferred_sink()
