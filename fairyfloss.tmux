#!/usr/bin/env bash
set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

slack_status="#($CURRENT_DIR/scripts/slack_status.sh)"
vpn_status="#($CURRENT_DIR/scripts/vpn_status.sh)"

# Battery icons
tmux set -g @batt_charged_icon ""
tmux set -g @batt_charging_icon "︎"     # nerdfonts f1e6
tmux set -g @batt_discharging_icon "︎♡"

# Colors
ff_lilac="#c5a3ff"
ff_seafoam="#c2ffdf"
ff_bg_purple="#5a5475"
ff_goldenrod="#fffea0"
ff_lavender="#8076aa"
ff_magenta="#f92672"
ff_silver="#f8f8f0"
ff_peach="#ff857f"

ff_slack_bg="$ff_magenta"
ff_slack_fg="$ff_silver"

# Glyphs
ff_left_separator=''
ff_left_separator_black=''
ff_right_separator=''
ff_right_separator_black=''
ff_session_symbol='❐'
ff_slack_symbol=''           # nerdfonts f198
ff_vpn_symbol=''             # nerdfonts f0ec
ff_calendar_symbol=''        # nerdfonts f133
ff_cpu_symbol=""             # nerdfonts f0ae

current_bg=""
current_fg=""


# new_segment() {
#     content="$1"
#     old_bg=$current_bg
#     old_fg=$current_fg
#     $current_bg="$2"
#     $current_fg="$3"
#
#     # If it's the same color scheme, do a same color separator
#     if [ "$current_bg" = $bg ]; then
#          return "$ff_right_separator$content "
#     # If it's the first segment, do a none to color scheme separator
#     elif [ -z "$current_bg" ]; then
#         return "#[fg=$current_bg]$right_separator_black#[fg=$current_fg,bg=$current_bg,bold]$content "
#     #If it's a different color scheme to a different color scheme, switch
#     else
#         return "#[fg=$current_bg]$right_separator_black#[fg=$current_fg,bg=$current_bg,bold]$content"
#     fi
#
# }
#
# status_module_clock(){
#     time_date_fg="#f8f8f0"      # silver
#     time_date_bg="#5a5475"      # bg purple
#
#     return new_segment $time_date_bg $time_date_bg " %R %a %b %d "
# }
#
# status_module_slack=$(new_segment $slack_status $ff_slack_bg $ff_slack_fg)
#
# status_module_vpn(){
#     return new_segment $vpn_status $ff_bg_purple $ff_silver
# }
#
configure_clock_mode() {
    tmux setw -g clock-mode-colour $ff_goldenrod
}

vpn() {
    if [ "$vpn_status" = "CONNECTED"]; then
        return "$right_separator$ff_vpn_symbol"
    fi
}


slack() {
    if [ "$slack_status" = "MENTION"]; then
        return "$right_separator$ff_vpn_symbol"
    fi
}

apply_theme() {
    left_separator=''
    left_separator_black=''
    right_separator=''
    right_separator_black=''

    # left_separator=''
    # left_separator_black=''
    # right_separator=''
    # right_separator_black=''

    configure_clock_mode

    # panes
    pane_border_fg="#c5a3ff"        # lilac
    pane_active_border_fg="#c2ffdf" # seafoam

    tmux set -g pane-border-style fg=$pane_border_fg \; set -g pane-active-border-style fg=$pane_active_border_fg
    #uncomment for fat borders
    #tmux set -ga pane-border-style bg=$pane_border_fg \; set -ga pane-active-border-style bg=$pane_active_border_fg

    display_panes_active_colour="#c2ffdf" # seafoam
    display_panes_colour="#c2ffdf"        # seafoam
    tmux set -g display-panes-active-colour $display_panes_active_colour \; set -g display-panes-colour $display_panes_colour

    # messages
    message_fg="#5a5475"     # bg purple
    message_bg="#fffea0"     # goldenrod
    message_attr=bold
    tmux set -g message-style fg=$message_fg,bg=$message_bg,$message_attr

    message_command_fg="#5a5475"     # bg purple
    message_command_bg="#fffea0"     # goldenrod
    tmux set -g message-command-style fg=$message_command_fg,bg=$message_command_bg,$message_attr

    # windows mode
    mode_fg="#5a5475"  # bg purple
    mode_bg="#fffea0"  # goldenrod
    mode_attr=bold
    tmux setw -g mode-style fg=$mode_fg,bg=$mode_bg,$mode_attr

    # status line
    status_fg="#c5a3ff" # lilac
    status_bg="#5a5475" # bg purple
    tmux set -g status-style fg=$status_fg,bg=$status_bg

    session_fg="#5a5475" # bg purple
    session_bg="#c2ffdf" # seafoam
    status_left="#[fg=$session_fg,bg=$session_bg,bold] ❐ #S #[fg=$session_bg,bg=$status_bg,nobold]$left_separator_black"
    if [ x"`tmux -q -L tmux_theme_status_left_test -f /dev/null new-session -d \; show -g -v status-left \; kill-session`" = x"[#S] " ] ; then
        status_left="$status_left "
    fi
    tmux set -g status-left-length 32 \; set -g status-left "$status_left"

    window_status_fg="#f8f8f0" # silver
    window_status_bg="#5a5475" # peach
    window_status_format="#I #W"
    tmux setw -g window-status-style fg=$window_status_fg,bg=$window_status_bg \; setw -g window-status-format "$window_status_format"

    window_status_current_fg="#f8f8f0" # silver
    window_status_current_bg="#ff857f" # peach
    window_status_current_format="#[fg=$window_status_bg,bg=$window_status_current_bg]$left_separator_black#[fg=$window_status_current_fg,bg=$window_status_current_bg,bold] #I $left_separator #W #[fg=$window_status_current_bg,bg=$status_bg,nobold]$left_separator_black"
    tmux setw -g window-status-current-format "$window_status_current_format"
    tmux set -g status-justify left

    window_status_activity_fg=default
    window_status_activity_bg=default
    window_status_activity_attr=underscore
    tmux setw -g window-status-activity-style fg=$window_status_activity_fg,bg=$window_status_activity_bg,$window_status_activity_attr

    window_status_bell_fg="#fffea0" # goldenrod
    window_status_bell_bg=default
    window_status_bell_attr=blink,bold
    tmux setw -g window-status-bell-style fg=$window_status_bell_fg,bg=$window_status_bell_bg,$window_status_bell_attr

    window_status_last_fg="#8076aa" # lavender
    window_status_last_attr=default
    tmux setw -g window-status-last-style $window_status_last_attr,fg=$window_status_last_fg

    time_date_fg="#f8f8f0"      # silver
    time_date_bg="#5a5475"      # bg purple
    battery_full_fg="#f92672"   # magenta
    battery_empty_fg="#f8f8f0"  # silver
    battery_bg="#5a5475"        # bg purple
    whoami_fg="#f8f8f0"         # silver
    whoami_bg="#ff857f"         # peach
    host_fg="#ff857f"           # peach
    host_bg="#f8f8f0"           # silver

    segment_color_dark="#[fg=$time_date_bg]$right_separator_black#[fg=$time_date_fg,bg=$time_date_bg,bold]"
    status_clock="$right_separator %R %a %b %d "
    segment_color_light="#[fg=$host_bg]$right_separator_black#[fg=$host_fg,bg=$host_bg,bold]"
    status_battery="#{battery_icon} #{battery_percentage}"

    status_right="︎$segment_color_dark$status_clock$segment_color_light$status_battery$right_separator$ff_cpu_symbol#{cpu_percentage}"

    tmux set -g status-right-length 64 \; set -g status-right "$status_right"

}

apply_theme
