# Libraries

from themes.theme import colors
from libqtile.widget import TaskList
from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import (Click, Drag, Group, ScratchPad, DropDown,
                             Key, Match, Screen)
from libqtile.lazy import lazy
from libqtile.command import lazy

# Variable Definitions

window_gap = 5
bar_gap = 5
bar_thickness = 24
terminal = "alacritty"
auto_fullscreen = True
bring_front_click = "floating_only"
cursor_warp = False
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "LG3D"

# Layouts

layouts = [
    layout.MonadTall(
        border_focus=colors["normal"]["red"],
        border_normal=colors["background"],
        border_width=2,
        margin=window_gap,
        single_border_width=0,
        ratio=0.5,
        change_ratio=0.05,
        change_size=20,
        max_ratio=0.75,
        min_ratio=0.25,
        min_secondary_size=85,
        new_client_position="bottom"
    )
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(wm_class="engrampa"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(wm_class="VirtualBox Machine")
    ],
    border_focus=colors["bright"]["black"],
    border_normal=colors["bright"]["black"],
    border_width=1,
    fullscreen_border_width=0,
    max_border_width=0
)

# Workspaces

groups = [
    ScratchPad("scratchpad", [
        DropDown("rdp", terminal + " -e 'runrdp'",
                 height=0.5, width=0.5, x=0.25, y=0.25, opacity=1.0)
    ]),
    Group(
        name="1",
        label="󰖟",
        layout="monadtall"
    ),
    Group(
        name="2",
        label="󰅩",
        layout="monadtall"
    ),
    Group(
        name="3",
        label="󰆍",
        layout="monadtall"
    ),
    Group(
        name="4",
        label="󰉖",
        layout="monadtall"
    ),
    Group(
        name="5",
        label="󰿏",
        layout="monadtall"
    ),
    Group(
        name="6",
        label="󰍺",
        layout="monadtall",
        matches=[
            Match(wm_class="VirtualBox Manager"),
            Match(wm_class="VirtualBox Machine")
        ]
    ),
    Group(
        name="7",
        label="󰢹",
        layout="monadtall",
        matches=[
            Match(wm_class="xfreerdp")
        ],
        init=False,
        persist=False
    )
]


# Keybindings

# Custom keybinding functions

@lazy.window.function
def moveFloatingWindow(window, x: int = 0, y: int = 0):
    if window.floating is True or \
       window.qtile.current_layout.name == 'floating':
        new_x = window.float_x + x
        new_y = window.float_y + y
        window.cmd_set_position_floating(new_x, new_y)


@lazy.window.function
def resizeFloatingWindow(window, width: int = 0, height: int = 0):
    if window.floating is True or \
       window.qtile.current_layout.name == 'floating':
        window.cmd_set_size_floating(window.width + width,
                                     window.height + height)


@lazy.function
def minimizeAll(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()


def getGroupState(group_name):
    group = qtile.groups_map.get(group_name)
    if group:
        return group.info()
    return None


@lazy.function
def moveFloatingWindowOnGroupChangeNext(qtile):
    qtilegroups = qtile.get_groups()
    current_group = qtile.current_group.name
    next_group = str(int(current_group)+1)
    next_group_state = getGroupState(next_group)

    for window in qtile.current_group.windows:

        if window.floating is not True or \
           window.qtile.current_layout.name == 'floating':
            continue

        for g in qtilegroups:
            if g == "scratchpad":
                continue

            if qtilegroups[g]["screen"] != 0:
                continue

            if next_group_state is None:
                window.cmd_togroup("1", switch_group=True)
                continue

            window.cmd_togroup(next_group, switch_group=True)
            return

    for g in qtilegroups:
        if g == "scratchpad":
            continue

        if qtilegroups[g]["screen"] != 0:
            continue

        if next_group_state is None:
            qtile.groups_map["1"].cmd_toscreen()
            continue

        qtile.groups_map[next_group].cmd_toscreen()
        return


@lazy.function
def moveFloatingWindowOnGroupChangePrev(qtile):
    groups_list = [group.name for group in qtile.groups if group.name != "scratchpad"]  # noqa E501
    qtilegroups = qtile.get_groups()
    current_group = qtile.current_group.name
    prev_group = str(int(current_group)-1)
    prev_group_state = getGroupState(prev_group)

    for window in qtile.current_group.windows:

        if window.floating is not True or \
           window.qtile.current_layout.name == 'floating':
            continue

        for g in qtilegroups:
            if g == "scratchpad":
                continue

            if qtilegroups[g]["screen"] != 0:
                continue

            if prev_group_state is None:
                window.cmd_togroup(groups_list[-1], switch_group=True)
                continue

            window.cmd_togroup(prev_group, switch_group=True)
            return

    for g in qtilegroups:
        if g == "scratchpad":
            continue

        if qtilegroups[g]["screen"] != 0:
            continue

        if prev_group_state is None:
            qtile.groups_map[groups_list[-1]].cmd_toscreen()
            continue

        qtile.groups_map[prev_group].cmd_toscreen()
        return


mod = "mod4"
keys = [Key(key[0], key[1], *key[2:]) for key in [

    # Move Floating Window

    ([mod, "mod1"], "l", moveFloatingWindow(x=50)),
    ([mod, "mod1"], "j", moveFloatingWindow(x=-50)),
    ([mod, "mod1"], "k", moveFloatingWindow(y=50)),
    ([mod, "mod1"], "i", moveFloatingWindow(y=-50)),

    # Resize Floating Window

    ([mod, "shift", "mod1"], "l", resizeFloatingWindow(width=50)),
    ([mod, "shift", "mod1"], "j", resizeFloatingWindow(width=-50)),
    ([mod, "shift", "mod1"], "k", resizeFloatingWindow(height=50)),
    ([mod, "shift", "mod1"], "i", resizeFloatingWindow(height=-50)),

    # Move Focus

    ([mod], "i", lazy.layout.up()),
    ([mod], "j", lazy.layout.left()),
    ([mod], "k", lazy.layout.down()),
    ([mod], "l", lazy.layout.right()),

    # Move Window

    ([mod, "control"], "i", lazy.layout.shuffle_up()),
    ([mod, "control"], "j", lazy.layout.swap_left()),
    ([mod, "control"], "k", lazy.layout.shuffle_down()),
    ([mod, "control"], "l", lazy.layout.swap_right()),
    ([mod], "space", lazy.layout.flip()),

    # Resize Window

    ([mod, "shift"], "i", lazy.layout.grow()),
    ([mod, "shift"], "j", lazy.layout.shrink_main()),
    ([mod, "shift"], "k", lazy.layout.shrink()),
    ([mod, "shift"], "l", lazy.layout.grow_main()),
    ([mod], "f", lazy.layout.maximize()),
    ([mod], "n", lazy.layout.normalize()),
    ([mod, "control"], "space", lazy.layout.reset()),

    # Window Commands

    ([mod, "shift"], "c", lazy.spawn("xkill")),
    ([mod], "c", lazy.window.kill()),
    ([mod, "control"], "c", lazy.window.toggle_minimize()),
    ([mod], "v", lazy.window.toggle_floating()),
    ([mod, "control"], "f", lazy.window.toggle_fullscreen()),

    # Layout manipulation

    ([mod], "t", lazy.hide_show_bar()),

    # Session Commands

    ([mod], "BackSpace", lazy.reload_config()),
    ([mod, "control"], "BackSpace", lazy.restart()),
    ([mod], "Delete", lazy.spawn("slock")),
    ([mod, "control"], "Delete", lazy.shutdown()),
    ([mod, "shift"], "Delete", lazy.spawn("systemctl suspend")),

    # Applications

    # ([mod], "r", lazy.spawncmd()),
    ([mod], "r", lazy.spawn("rofi -modi drun,run -show drun")),
    ([mod], "Return", lazy.spawn(terminal)),
    ([mod], "period", lazy.spawn("rofi -modi emoji -show emoji")),
    ([mod], "b", lazy.spawn("changebg")),
    ([mod], "q", lazy.spawn("firefox")),
    ([mod], "w", lazy.spawn(terminal + " -e vim")),
    ([mod], "e", lazy.spawn("thunar")),
    ([mod], "g", lazy.spawn(terminal + " -e htop")),

    # Media Keys

    ([], "XF86Explorer", lazy.spawn("thunar")),
    ([], "XF86HomePage", minimizeAll()),
    ([], "XF86Mail", lazy.spawn("firefox")),
    ([], "XF86Calculator", lazy.spawn("galculator")),
    ([], "XF86AudioMute", lazy.spawn("pulsemixer --toggle-mute")),
    ([], "XF86AudioLowerVolume", lazy.spawn("changeVolume -1")),
    ([], "XF86AudioRaiseVolume", lazy.spawn("changeVolume +1")),

    # Groups manipulation

    ([mod], "tab", lazy.screen.next_group()),
    ([mod, "shift"], "tab", lazy.screen.prev_group()),

    ([mod], "period", lazy.screen.next_group()),
    ([mod], "comma", lazy.screen.prev_group()),

    ([mod, "control"], "period", moveFloatingWindowOnGroupChangeNext()),
    ([mod, "control"], "comma", moveFloatingWindowOnGroupChangePrev()),

    ([mod, "control"], "tab", moveFloatingWindowOnGroupChangeNext()),
    ([mod, "control", "shift"], "tab", moveFloatingWindowOnGroupChangePrev()),

    # Scratchpads

    ([mod], 'd', lazy.group['scratchpad'].dropdown_toggle('rdp'))
]]

mouse = [
    Drag([mod], "Button1",
         lazy.window.set_position_floating(),
         start=lazy.window.get_position()
         ),

    Drag([mod], "Button3",
         lazy.window.set_size_floating(),
         start=lazy.window.get_size()
         ),

    Click([mod], "Button2",
          lazy.window.bring_to_front()
          ),
]

for i in groups:
    if len(i.name) == 1:
        keys.extend([
            Key([mod], i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
                ),
            Key([mod, "shift"], i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(
                    i.name
                    ),
                ),
            Key([mod, "control"], i.name, lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name))
        ])

# Widgets

widget_defaults = dict(
    background=colors["background"],
    foreground=colors["foreground"],
    font="Hack Nerd Font Bold",
    fontsize=12,
    padding=5,
)
extension_defaults = widget_defaults.copy()


def Spacer(p=None):
    if p is None or p == "":
        return widget.Spacer()

    spacer = widget.Spacer(
        length=p,
    )
    return spacer


def Icon(i, c):
    icon = widget.TextBox(
        font="Material Design Icons Desktop",
        text=i,
        fontsize=18,
        padding=0,
        foreground=c,
    )
    return icon


def GroupBox():
    groupbox = widget.GroupBox(
        font="Material Design Icons Desktop",
        fontsize=15,
        highlight_method="line",
        urgent_alert_method="line",
        active=extension_defaults["foreground"],
        inactive=colors["bright"]["black"],
        highlight_color=extension_defaults["background"],
        this_current_screen_border=colors["normal"]["red"],
        this_screen_border=colors["normal"]["red"],
        borderwidth=2,
        disable_drag=True,
        use_mouse_wheel=False
    )
    return groupbox


class CustomTaskList(TaskList):
    def button_press(self, x, y, button):
        window = self.get_clicked(x, y)
        if button == 2:  # Middle mouse button
            if window:
                window.cmd_kill()
        elif button == 3:  # Secondary mouse button
            if window:
                window.cmd_toggle_minimize()
        else:
            super().button_press(x, y, button)


def TaskList():
    tasklist = CustomTaskList(
            markup=True,
            border=colors["normal"]["red"],
            unfocused_border=colors["bright"]["black"],
            urgent_border=colors["urgent"],
            highlight_method="block",
            markup_focused="<span font='Hack Nerd Font Bold 9'> {}</span>",
            markup_normal="<span font='Hack Nerd Font Bold 9'> {}</span>",
            markup_floating="""<span
                            font='Hack Nerd Font Bold 9' foreground='{color}'
                            > 󰖲 </span> <span
                            font='Hack Nerd Font Bold 9'
                            >{desc} </span>""".format(
                                color=colors["normal"]["black"],
                                desc="{}"
                            ),
            markup_minimized="""<span
                            font='Hack Nerd Font Bold 9' foreground='{color}'
                            > 󰖰 </span> <span font='Hack Nerd Font Bold 9'
                            >{desc} </span>""".format(
                                color=colors["normal"]["black"],
                                desc="{}"
                            ),
            markup_maximized="""<span
                            font='Hack Nerd Font Bold 9' foreground='{color}'
                            > 󰖯 </span> <span font='Hack Nerd Font Bold 9'
                            >{desc} </span>""".format(
                                color=colors["normal"]["black"],
                                desc="{}"
                            ),
            borderwidth=1,
            icon_size=0,
            margin_y=2,
            max_title_width=128,
            padding_x=3,
            padding_y=3,
            rounded=True,
            spacing=10,
            title_width_method="uniform",
            urgent_alert_method="text"
        )
    return tasklist


def Clock(c):
    clock = widget.Clock(
        format="""<span font='Hack Nerd Font Bold 9' underline='single'
                underline_color='{color}'
                >%a %d - %I:%M %p</span>   """.format(color=c),
        mouse_callbacks={
            "Button1": lazy.spawn("show-calendar curr"),
            "Button4": lazy.spawn("show-calendar next"),
            "Button5": lazy.spawn("show-calendar prev")
        }
    )
    return clock


def Launcher(i, c):
    launcher = widget.TextBox(
        font="Material Design Icons Desktop",
        text=i,
        fontsize=18,
        padding=0,
        foreground=c,
        mouse_callbacks={"Button1": lazy.spawn("rofi-app_launcher")}
    )
    return launcher


def Systray():
    systray = widget.Systray(
        padding=5
    )
    return systray


def VolumeIcon(i, c):
    volumeicon = widget.TextBox(
        font="Material Design Icons Desktop",
        text=i,
        fontsize=18,
        padding=0,
        foreground=c,
        mouse_callbacks={
            "Button1": lazy.spawn(terminal + " --command pulsemixer"),
            "Button3": lazy.spawn("pulsemixer --toggle-mute"),
            "Button4": lazy.spawn("changeVolume +1"),
            "Button5": lazy.spawn("changeVolume -1")
            }
    )
    return volumeicon


def QuickExit(i, c):
    quickexit = widget.QuickExit(
        foreground=c,
        default_text=i,
        fontsize=18,
        mouse_callbacks={"Button1": lazy.spawn("rofi-exit_menu")}
    )
    return quickexit


# Bars

screens = [
    Screen(
        top=bar.Bar(
            [
                Spacer(5),
                GroupBox(),
                Spacer(10),
                TaskList(),
                Icon("    󰸗", colors["foreground"]),
                Clock(colors["foreground"]),
                Spacer(),
                Systray(),
                VolumeIcon(" 󰕾", colors["foreground"]),
                Spacer(10),
                Launcher("󰍜", colors["bright"]["black"]),
                Spacer(10),
                QuickExit("󰐦", colors["bright"]["black"]),
                Spacer(10)
            ],
            bar_thickness,
            background=extension_defaults["background"],
            border_width=5,
            border_color=extension_defaults["background"],
            margin=[bar_gap, bar_gap, 0, bar_gap],
            opacity=1
        ),
    ),
]


@hook.subscribe.client_focus
def bringFloatingWindowToFront(qtile):
    for window in qtile.group.windows:

        if window.state is 3: return
        if window.group is None: continue

        if hasattr(window, 'floating') and window.floating:
            window.cmd_bring_to_front()
