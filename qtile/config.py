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

# IMPORTS
import os
import subprocess
import colors
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
# Make sure 'qtile-extras' is installed or this config will not work.
# from qtile_extras import widget
# from qtile_extras.widget.decorations import BorderDecoration

# VARIABLES
mod = "mod4" # Sets mod key to SUPER
alt = "mod1" # Sets mod key to ALT
myTerm = "kitty" # My terminal of choice
myBrowser = "thorium-browser" # My browser of choice
myFiles = "thunar" # My file manager of choice

# CUSTOM FUNCTIONS
# A function for hide/show all the windows in a group
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()

# Allows you to input a name when adding treetab section.
@lazy.layout.function
def add_treetab_section(layout):
    prompt = qtile.widgets_map["prompt"]
    prompt.start_input("Section name: ", layout.cmd_add_section)

# KEY BINDINGS
keys = [
    ## ESSENTIALS
    Key([mod], "Return", lazy.spawn(myTerm), desc="Launch terminal"),
    Key([mod], "e", lazy.spawn(myFiles), desc="Launch thunar"),
    Key([mod], "b", lazy.spawn(myBrowser), desc="Launch browser"),

    # Brightness & Volume Control
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%"), desc="Increase brightness"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-"), desc="Decrease brightness"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer --increase 5"), desc="Increase volume"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer --decrease 5"), desc="Decrease volume"),
    Key([], "XF86AudioMute", lazy.spawn("pamixer --toggle-mute"), desc="Mute/Unmute volume"),

    # Flameshot
    Key([alt], "x", lazy.spawn("flameshot gui"), desc="Capture selected area"),
    Key([alt], "s", lazy.spawn("flameshot full"), desc="Capture full screen"),

    # Rofi
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Run rofi launcher for applications"),
    Key([mod], "v", lazy.spawn("env CM_LAUNCHER=rofi clipmenu"), desc="Run clipmenu with rofi"),
    Key([mod], "p", lazy.spawn("/usr/local/bin/rofi-logout.sh"), desc="Logout menu"),

    ## WINDOWS
    # Column Layout
    # Resize Windows
    Key([mod], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Monadtall Layout
    # This is mainly for the 'monadtall' and 'monadwide' layouts
    # although it does also work in the 'bsp' and 'columns' layouts.
    Key([mod], "equal",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the right"
    ),
    Key([mod], "minus",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left"
    ),

    # Toggle between split and unsplit sides of stack, 
    # Split = all windows displayed, 
    # Unsplit = 1 window displayed, like Max layout, but still with, multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    # Common Window Keybindings
    # Switch focus between windows
    Key([mod, "shift"], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod, "shift"], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod, "shift"], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod, "shift"], "k", lazy.layout.up(), desc="Move focus up"),
    
    # Arrange the windows
    # Some layouts like 'monadtall' only need to use j/k to move
    # through the stack, but other layouts like 'columns' will
    # require all four directions h/j/k/l to move around.
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "control"], "h",
        lazy.layout.shuffle_left(),
        lazy.layout.move_left().when(layout=["treetab"]),
        desc="Move window to the left/move tab left in treetab"),

    Key([mod, "control"], "l",
        lazy.layout.shuffle_right(),
        lazy.layout.move_right().when(layout=["treetab"]),
        desc="Move window to the right/move tab right in treetab"),

    Key([mod, "control"], "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down().when(layout=["treetab"]),
        desc="Move window down/move down a section in treetab"
    ),
    Key([mod, "control"], "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up().when(layout=["treetab"]),
        desc="Move window downup/move up a section in treetab"
    ),

    # Treetab Layout prompt
    Key([mod, "shift"], "a", add_treetab_section, desc='Prompt to add new section in treetab'),

    # Any Layout Keybindings
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),
    Key([mod, "shift"], "m", minimize_all(), desc="Toggle hide/show all windows on current group"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

# GROUPS/WORKSPACES
groups = []
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9",]
group_labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9",]
# group_labels = ["DEV", "WWW", "SYS", "DOC", "VBOX", "CHAT", "MUS", "VID", "GFX",]
# group_labels = ["", "", "", "", "", "", "", "", "",]

group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall"]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))
 
for i in groups:
    keys.extend(
        [
            # mod + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )

# LAYOUTS
colors = colors.TokyoNight

layout_theme= {"border_width": 2,
               "border_focus": colors[8],
               "border_normal": colors[0]
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Columns(**layout_theme,insert_position=1),
    layout.Max(
        border_width = 0,
        margin = 0,
    ),
    # layout.TreeTab(
    #     font = "JetBrainsMono Nerd Font",
    #     fontsize = 11,
    #     border_width = 0,
    #     bg_color = colors[0],
    #     active_bg = colors[8],
    #     active_fg = colors[2],
    #     inactive_bg = colors[1],
    #     inactive_fg = colors[0],
    #     padding_left = 8,
    #     padding_x = 8,
    #     padding_y = 6,
    #     sections = ["ONE", "TWO", "THREE"],
    #     section_fontsize = 10,
    #     section_fg = colors[7],
    #     section_top = 15,
    #     section_bottom = 15,
    #     level_shift = 8,
    #     vspace = 3,
    #     panel_width = 240
    #     ),
    # layout.Tile(
    #     shift_windows=True,
    #     border_width = 0,
    #     margin = 0,
    #     ratio = 0.335,
    # ),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(**layout_theme, num_stacks=2),
    # layout.Bsp(**layout_theme),
    # layout.Matrix(**layout_theme),
    # layout.MonadWide(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Zoomy(**layout_theme),
]

# WIDGETS & BAR
widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=12,
    padding=4,
    background=colors[0]
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    fontsize = 14,
                    margin_y = 5,
                    margin_x = 5,
                    padding_y = 0,
                    padding_x = 1,
                    borderwidth = 2,
                    active = colors[8],
                    inactive = colors[1],
                    rounded = False,
                    highlight_color = colors[2],
                    highlight_method = "line",
                    this_current_screen_border = colors[7],
                    this_screen_border = colors [4],
                ),
                widget.TextBox(
                    text="|", 
                    font = "JetBrainsMono Nerd Font",
                    foreground = colors[1],
                    padding = 2,
                    fontsize = 13
                    ),
                widget.CurrentLayoutIcon(
                    scale=0.7, 
                    padding=4
                ),
                widget.CurrentLayout(
                    foreground = colors[1],
                    padding = 3,
                    fontsize=13
                ),
                widget.TextBox(
                    text="|", 
                    font = "JetBrainsMono Nerd Font",
                    foreground = colors[1],
                    padding = 2,
                    fontsize = 13
                    ),
                widget.WindowName(
                    foreground = colors[6],
                    fontsize = 14
                ),
                widget.Prompt(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.GenPollText(
                    func=lambda: f"Uptime: {subprocess.check_output("uptime --pretty", shell=True, text=True).strip().replace("up ", "")}",
                    update_interval = 60,  # Updates every 60 seconds
                    foreground = colors[4],
                ),
                widget.Battery(
                    format="Bat:{percent:2.0%}",
                    update_interval=30,  # Updates every 30 seconds
                    foreground = colors[8],
                ),
                widget.Memory(
                    format="Mem:{MemUsed:.1f}GB",  # Shows memory used in GB
                    measure_mem="G",          # Measure in GB
                    update_interval=30,      # Updates every 30 second
                    foreground = colors[7],
                ),
                widget.Clock(
                    format="%A,%b %d %H:%M",
                    foreground = colors[5],
                ),
                widget.Systray(),
            ],
            21,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# AUTOSTART
@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
