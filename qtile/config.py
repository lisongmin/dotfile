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

from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget
from libqtile import hook
import subprocess
import os

mod = "mod4"
scrot_option = " -e 'mv $f /tmp/%Y%m%dT%H%M%S_$wx$h_scrot.png'"

keys = [
    # Switch between windows in current stack pane
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "h", lazy.layout.grow()),
    Key([mod], "l", lazy.layout.shrink()),
    Key([mod], "n", lazy.layout.next()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod], "space", lazy.next_layout()),
    Key([mod], "t", lazy.window.toggle_floating()),

    Key([mod], "w", lazy.next_screen()),

    Key([mod, "shift"], "c", lazy.window.kill()),

    Key([mod], "q", lazy.restart()),
    Key([mod, "shift"], "q", lazy.spawn(
        'cinnamon-session-quit --logout')),
    Key([mod, "shift"], "s", lazy.spawn(
        'systemctl suspend -i')),

    Key(["mod1"], "F2", lazy.spawncmd()),

    Key(["control", "mod1"], "l", lazy.spawn(
        "cinnamon-screensaver-command -l")),
    Key([], "Print", lazy.spawn('scrot' + scrot_option)),
    Key(['control', 'mod1'], "Print", lazy.spawn(
        os.path.join(os.path.dirname(__file__), 'scrot_s'))),

    Key([mod], "f", lazy.spawn("fcitx -r -d")),
    Key([mod], "Return", lazy.spawn("xfce4-terminal")),
    Key([mod, "shift"], "w", lazy.spawn("firefox")),
    Key([mod, "shift"], "f", lazy.spawn("nemo --no-desktop")),
    Key([mod, "shift"], "m", lazy.spawn("thunderbird")),
    Key([mod, "shift"], "v", lazy.spawn("virt-viewer -c qemu:///system win10")),

    Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer set Master 4%-')),
    Key([], 'XF86AudioMute', lazy.spawn('amixer set Master toggle')),
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer set Master 4%+')),
    Key([], 'XF86AudioPlay', lazy.spawn('mpc toggle')),
    Key([], 'XF86AudioStop', lazy.spawn('mpc stop')),
    Key([], 'XF86AudioPrev', lazy.spawn('mpc prev')),
    Key([], 'XF86AudioNext', lazy.spawn('mpc next')),

    # backlight adjust.
    # Key([], "XF86KbdBrightnessUp", lazy.spawn("maclight keyboard up")),
    # Key([], "XF86KbdBrightnessDown", lazy.spawn("maclight keyboard down")),
    # Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight +5%")),
    # Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -5%")),
]

groups = [Group('a'),
          Group('o', [Match(wm_class=['Firefox'])]),
          Group('e', layouts=[layout.max.Max()]),
          Group('u', [Match(wm_class=['Wine'])]),
          Group('i', [Match(wm_class=['Thunderbird'])]),
          Group('d', [Match(wm_class=['TelegramDesktop'])],
                layouts=[layout.stack.Stack(margin=1)])
          ]

for i in groups:
    # mod1 + letter of group = switch to group
    keys.append(
        Key([mod], i.name, lazy.group[i.name].toscreen())
    )

    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name))
    )

layouts = [
    layout.max.Max(),
    layout.xmonad.MonadTall()
]

widget_defaults = dict(
    # font='Source Han Sans',
    font='文泉驿正黑',
    fontsize=20,
    padding=1,
)


def init_top_bar_widgets():
    widgets = [widget.GroupBox(),
               widget.Prompt(),
               widget.WindowName(),
               widget.Sep(),
               ]

    # network
    nets = os.listdir('/sys/class/net')
    for n in nets:
        if n.startswith('enp') or n.startswith('wlp'):
            widgets.extend([widget.Net(interface=n, update_interval=2),
                            widget.Sep()])

    widgets.append(widget.CPUGraph(frequency=2))

    # bettery
    battery_names = os.listdir('/sys/class/power_supply')
    battery_names = [x for x in battery_names if x.startswith('BAT')]
    for n in battery_names:
        widgets.append(widget.Battery(battery_name=n, update_delay=5))

    if battery_names:
        widgets.append(widget.Sep())

    # backlight
    backlight_names = os.listdir('/sys/class/backlight')
    for n in backlight_names:
        widgets.append(widget.Backlight(backlight_name=n))

    if backlight_names:
        widgets.append(widget.Sep())

    widgets.extend([
        widget.ThermalSensor(),
        widget.Systray(),
        widget.Clock(format='%a %H:%M %m-%d')
    ])
    return widgets


bar.Bar.defaults
screens = [
    Screen(top=bar.Bar(init_top_bar_widgets(), 24, opacity=0.7)),
    Screen()
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating()
auto_fullscreen = True

from logging import INFO
log_level = INFO

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
# wmname = "LG3D"
wmname = "Qtile"


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])


@hook.subscribe.screen_change
def restart_on_screen_change(qtile, ev):
    print(ev)
    qtile.cmd_restart()
