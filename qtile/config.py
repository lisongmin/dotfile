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

keys = [
    # Switch between windows in current stack pane
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    # Key([mod], "h", lazy.layout.grow()),
    # Key([mod], "l", lazy.layout.shrink()),
    Key([mod], "n", lazy.layout.next()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod], "space", lazy.next_layout()),
    Key([mod], "t", lazy.window.toggle_floating()),

    # 'win + w' switch to next screen
    Key([mod], "w", lazy.next_screen()),

    Key([mod, "shift"], "c", lazy.window.kill()),

    # 'win + q' reload qtile config
    Key([mod], "q", lazy.restart()),
    # 'win + shift + q' logout
    Key([mod, "shift"], "q", lazy.spawn(
        f'loginctl terminate-session {os.environ.get("XDG_SESSION_ID")}')),
    # 'win + shift + s' to suspend os
    Key([mod, "shift"], "s", lazy.spawn(
        'systemctl suspend -i')),
    # 'ctrl + alt + l' to  lock screan
    Key(["control", "mod1"], "l", lazy.spawn(
        "loginctl lock-session")),

    # 'alt + F2' to run command
    Key(["mod1"], "F2", lazy.spawncmd()),

    # take a sreenshot
    Key([], "Print", lazy.spawn('flameshot gui -p /tmp/ -d 0.2')),
    # take a full screanshot and save to file
    Key(['shift'], "Print", lazy.spawn('flameshot full -p /tmp')),
    # take a full screanshot to clipboard
    Key(['control', 'shift'], "Print", lazy.spawn('flameshot full -c')),

    Key([mod], "f", lazy.spawn("fcitx -r -d")),
    Key([mod], "Return", lazy.spawn("termite")),
    Key([mod, "shift"], "w", lazy.spawn("firefox")),
    Key([mod, "shift"], "f", lazy.spawn("nemo")),
    Key([mod, "shift"], "m", lazy.spawn("thunderbird")),
    Key([mod, "shift"], "v", lazy.spawn("virt-viewer -c qemu:///system win10")),

    Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer set Master 4%-')),
    Key([], 'XF86AudioMute', lazy.spawn('amixer set Master toggle')),
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer set Master 4%+')),
    Key([], 'XF86AudioPlay', lazy.spawn('xmms2 toggle')),
    Key([], 'XF86AudioStop', lazy.spawn('xmms2 stop')),
    Key([], 'XF86AudioPrev', lazy.spawn('xmms2 prev')),
    Key([], 'XF86AudioNext', lazy.spawn('xmms2 next')),
    Key([], 'XF86MonBrightnessDown', lazy.spawn('brightnessctl s 10%-')),
    Key([], 'XF86MonBrightnessUp', lazy.spawn('brightnessctl s 10%+')),
]

groups = [Group('a'),
          Group('o', [Match(wm_class=['Firefox', 'firefox'])]),
          Group('e', layouts=[layout.max.Max()]),
          Group('u', [Match(wm_class=['zoom'])],
                layouts=[layout.zoomy.Zoomy()]),
          Group('d', [Match(wm_class=['TelegramDesktop', 'Mattermost'])],
                layouts=[layout.stack.Stack(margin=1)]),
          Group('h', [Match(wm_class=['Thunderbird'])]),
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
    fontsize=14,
    padding=1,
)


def get_sensor_tag():
    p = subprocess.Popen(['sensors'], stdout=subprocess.PIPE)
    out, dummy_err = p.communicate()
    out = out.decode()
    tags = ['Tdie', 'Core 0']
    for tag in tags:
        if tag in out:
            return tag

    return None


if os.environ.get('XDG_SESSION_DESKTOP') == 'plasma-qtile':
    screens = [
        Screen()
    ]
else:
    widgets = [widget.GroupBox(), widget.Prompt(),
               widget.WindowName(), widget.Sep(), ]

    nets = os.listdir('/sys/class/net')
    eth = ''
    wlan = ''
    if 'br0' in nets:
        eth = 'br0'

    for n in nets:
        if not eth and n.startswith('enp'):
            eth = n
        elif not wlan and n.startswith('wl'):
            wlan = n

    widgets.extend([
        widget.Net(interface=eth, update_interval=2),
        widget.Sep(),
        widget.Net(interface=wlan, update_interval=2),
        ])

    widgets.extend([
        widget.CPUGraph(frequency=2),
        widget.ThermalSensor(tag_sensor=get_sensor_tag()),
        widget.Sep(),
        ])

    battery_name = None
    if os.path.exists('/sys/class/power_supply/BAT0/status'):
        battery_name = "BAT0"
        widgets.append(widget.Battery(battery_name=battery_name))

    widgets.extend([
        widget.Systray(),
        widget.Clock(format='%a %H:%M %m-%d'),
        ])

    bar.Bar.defaults
    top = bar.Bar(widgets,
                  24,
                  opacity=0.7
                  )

    screens = [
        Screen(
            top=top
        ),
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
floating_layout = layout.Floating(
    [{'wmclass': 'flameshot'},
     {'wname': 'Select a window or an application that you want to share',
      'wmclass': 'zoom'}
     ])

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
