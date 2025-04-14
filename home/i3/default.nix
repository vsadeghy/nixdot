{
  pkgs,
  config,
  ...
}: let
  super = "Mod4";
  alt = "Mod1";
  mod1 = "Control";
  mod2 = alt;
  meh = "Control+Shift+Mod1";
  browser = "zen";
  terminal = "ghostty";
  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";
  ws7 = "7";
  ws8 = "8";
  ws9 = "9";
  ws10 = "10";
  refresh_i3status = "killall -SIGUSR1 i3status";

  mode_system = "(l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown";
  mode_gaps = "Gaps: (o) outer, (i) inner";
  mode_gaps_outer = "Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)";
  mode_gaps_inner = "Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)";
  leftMonitor = "HDMI-0";
  rightMonitor = "DP-2";
  primary = rightMonitor;
  secondary =
    if (primary == rightMonitor)
    then leftMonitor
    else rightMonitor;
  # getWorkspace = diff: ''"$(( $( i3-msg -t get_workspaces | jq '.[] | select(.focused).num' ) + ${diff}))"'';
  # prev = "number " + getWorkspace "-1";
  # next = getWorkspace "1";
  prev = "prev";
  next = "next";
  palette = builtins.mapAttrs (_: color: "#" + color) config.colorScheme.palette;
  inherit (import ./lock-color.nix {inherit pkgs palette;}) lock-color;
in {
  home.packages = with pkgs; [
    xorg.xrandr
    blueman
    nekoray
    jq
    lock-color
  ];
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraConfig = ''
      default_border pixel 1
      default_floating_border normal
      for_window [urgent=latest] focus
    '';
    config = {
      modifier = super;
      workspaceAutoBackAndForth = true;
      gaps = {
        inner = 14;
        outer = -2;
      };
      floating = {
        criteria = map (c: {class = c;}) [
          "Pavucontrol"
          "Variety"
          "Lxappearance"
          "Nitrogen"
          "nekoray"
          "blueman-manager-wrapped"
          "Galculator"
        ];
      };
      workspaceOutputAssign = let
        toMonitor = monitor: workspace:
          map (ws: {
            output = monitor;
            workspace = ws;
          })
          workspace;
      in
        toMonitor leftMonitor [ws1 ws2 ws3 ws4] ++ toMonitor rightMonitor [ws5 ws6 ws7 ws8];
      startup = [
        {command = "xrandr --output ${secondary} --mode 1280x1024 --pos 0x0 --rotate normal --rate 75 --output ${primary} --primary --mode 1920x1080 --pos 1285x0 --rotate normal --rate 144";}
        {command = "xss-lock --transfer-sleep-lock lock-color";}
        {command = "nitrogen --restore";}
        {command = "blueman-applet";}
        {command = "nekoray";}
        # { command = "clipit"; }
        # { command = "pcmanfm -d"; }
      ];
      modes = {
        ${mode_system} = {
          l = "exec --no-startup-id lock-color         , mode default";
          s = "exec --no-startup-id systemctl suspend  , mode default";
          u = "exec --no-startup-id i3exit switch_user , mode default";
          e = "exec --no-startup-id i3-msg exit        , mode default";
          h = "exec --no-startup-id systemctl hibernate, mode default";
          r = "exec --no-startup-id systemctl reboot   , mode default";
          "Shift+s" = "exec --no-startup-id systemctl poweroff , mode default";

          Return = "mode default";
          Escape = "mode default";
        };
        resize = {
          j = "resize shrink height 10 px or 10 ppt";
          k = "resize grow height 10 px or 10 ppt";
          l = "resize shrink width 10 px or 10 ppt";
          semicolon = "resize grow width 10 px or 10 ppt";

          Return = "mode default";
          Escape = "mode default";
        };
        ${mode_gaps} = {
          o = ''mode "${mode_gaps_outer}"'';
          i = ''mode "${mode_gaps_inner}"'';
          Return = "mode default";
          Escape = "mode default";
        };
        ${mode_gaps_inner} = {
          plus = "gaps inner current plus 5";
          minus = "gaps inner current minus 5";
          "0" = "gaps inner current set 0";

          "Shift+plus" = "gaps inner all plus 5";
          "Shift+minus" = "gaps inner all minus 5";
          "Shift+0" = "gaps inner all set 0";

          Return = "mode default";
          Escape = "mode default";
        };
        "${mode_gaps_outer}" = {
          plus = "gaps outer current plus 5";
          minus = "gaps outer current minus 5";
          "0" = "gaps outer current set 0";

          "Shift+plus" = "gaps outer all plus 5";
          "Shift+minus" = "gaps outer all minus 5";
          "Shift+0" = "gaps outer all set 0";

          Return = "mode default";
          Escape = "mode default";
        };
      };
      keybindings = {
        ## main
        "${super}+Return" = "exec ${terminal}";
        "${super}+d" = "exec --no-startup-id dmenu_run";
        "${super}+q" = "kill";

        ## modes
        "${super}+x" = ''mode "${mode_system}"'';
        "${super}+g" = ''mode "${mode_gaps}"'';
        "${super}+r" = ''mode "resize"'';

        ## borders
        "${super}+u" = "border none";
        "${super}+y" = "border pixel 1";
        "${super}+n" = "border normal";

        ## multimedia
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@   +10%  && ${refresh_i3status}";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@   -10%  && ${refresh_i3status}";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute   @DEFAULT_SINK@   toggle && ${refresh_i3status}";
        "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && ${refresh_i3status}";
        "XF86MonBrightnessUp" = "exec --no-startup-id xbacklight -inc 20";
        "XF86MonBrightnessDown" = "exec --no-startup-id xbacklight -dec 20";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioStop" = "exec playerctl stop";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        "Print" = "exec --no-startup-id flameshot gui";

        ## launcher
        "${meh}+b" = "exec ${browser}";
        "${meh}+y" = "exec firefox";
        "${meh}+o" = "exec obsidian";
        "${meh}+f" = "exec ferdium";
        "${meh}+e" = "exec pcmanfm";
        "${meh}+c" = "exec galculator";

        ## split orientation
        #"${mod}+h" = "split h;exec notify-send 'tile horizontally'";
        #"${mod}+v" = "split v;exec notify-send 'tile vertically'";
        "${super}+semicolon" = "split toggle";

        #enter fullscreen mode for the focused container
        "${super}+f" = "fullscreen toggle";

        #change container layout (stacked, tabbed, toggle split)
        "${super}+s" = "layout stacking";
        "${super}+w" = "layout tabbed";
        "${super}+shift+semicolon" = "layout toggle split";

        ## toggle tiling / floating
        "${super}+${mod2}+space" = "floating toggle";

        ## change focus between tiling / floating windows
        "${super}+space" = "focus mode_toggle";

        ## toggle sticky
        "${super}+${mod2}+s" = "sticky toggle";

        ## focus the parent container
        "${super}+a" = "focus parent";

        ## move the currently focused window to the scratchpad
        "${super}+${mod2}+minus" = "move scratchpad";

        ## Show the next scratchpad window or hide the focused scratchpad window.
        ## If there are multiple scratchpad windows, this command cycles through them.
        "${super}+minus" = "scratchpad show";

        ## switch to workspace
        "${super}+h" = "focus left";
        "${super}+j" = "focus down";
        "${super}+k" = "focus up";
        "${super}+l" = "focus right";
        "${super}+Left" = "focus left";
        "${super}+Down" = "focus down";
        "${super}+Up" = "focus up";
        "${super}+Right" = "focus right";
        "${super}+o" = "workspace back_and_forth";
        "${super}+1" = "workspace number ${ws1}";
        "${super}+2" = "workspace number ${ws2}";
        "${super}+3" = "workspace number ${ws3}";
        "${super}+4" = "workspace number ${ws4}";
        "${super}+5" = "workspace number ${ws5}";
        "${super}+6" = "workspace number ${ws6}";
        "${super}+7" = "workspace number ${ws7}";
        "${super}+8" = "workspace number ${ws8}";
        "${super}+9" = "workspace number ${ws9}";
        "${super}+0" = "workspace number ${ws10}";
        "${super}+bracketleft" = "workspace ${prev}";
        "${super}+bracketright" = "workspace ${next}";

        ## move focused container to workspace
        "${super}+${mod2}+h" = "move left";
        "${super}+${mod2}+j" = "move down";
        "${super}+${mod2}+k" = "move up";
        "${super}+${mod2}+l" = "move right";
        "${super}+${mod2}+Left" = "move left";
        "${super}+${mod2}+Down" = "move down";
        "${super}+${mod2}+Up" = "move up";
        "${super}+${mod2}+Right" = "move right";
        "${super}+${mod2}+o" = "move container to workspace back_and_forth";
        "${super}+${mod2}+1" = "move container to workspace number ${ws1}";
        "${super}+${mod2}+2" = "move container to workspace number ${ws2}";
        "${super}+${mod2}+3" = "move container to workspace number ${ws3}";
        "${super}+${mod2}+4" = "move container to workspace number ${ws4}";
        "${super}+${mod2}+5" = "move container to workspace number ${ws5}";
        "${super}+${mod2}+6" = "move container to workspace number ${ws6}";
        "${super}+${mod2}+7" = "move container to workspace number ${ws7}";
        "${super}+${mod2}+8" = "move container to workspace number ${ws8}";
        "${super}+${mod2}+9" = "move container to workspace number ${ws9}";
        "${super}+${mod2}+0" = "move container to workspace number ${ws10}";
        "${super}+${mod2}+bracketleft" = "move container to workspace ${prev}";
        "${super}+${mod2}+bracketright" = "move container to workspace ${next}";

        ## move focused container to workspace and switch to it
        "${super}+${mod1}+h" = "move left; focus left";
        "${super}+${mod1}+j" = "move down; focus down";
        "${super}+${mod1}+k" = "move up; focus up";
        "${super}+${mod1}+l" = "move right; focus right";
        "${super}+${mod1}+Left" = "move left; focus left";
        "${super}+${mod1}+Down" = "move down; focus down";
        "${super}+${mod1}+Up" = "move up; focus up";
        "${super}+${mod1}+Right" = "move right; focus right";
        "${super}+${mod1}+o" = "move container to workspace back_and_forth; workspace back_and_forth";
        "${super}+${mod1}+1" = "move container to workspace number ${ws1}; workspace number ${ws1}";
        "${super}+${mod1}+2" = "move container to workspace number ${ws2}; workspace number ${ws2}";
        "${super}+${mod1}+3" = "move container to workspace number ${ws3}; workspace number ${ws3}";
        "${super}+${mod1}+4" = "move container to workspace number ${ws4}; workspace number ${ws4}";
        "${super}+${mod1}+5" = "move container to workspace number ${ws5}; workspace number ${ws5}";
        "${super}+${mod1}+6" = "move container to workspace number ${ws6}; workspace number ${ws6}";
        "${super}+${mod1}+7" = "move container to workspace number ${ws7}; workspace number ${ws7}";
        "${super}+${mod1}+8" = "move container to workspace number ${ws8}; workspace number ${ws8}";
        "${super}+${mod1}+9" = "move container to workspace number ${ws9}; workspace number ${ws9}";
        "${super}+${mod1}+0" = "move container to workspace number ${ws10}; workspace number ${ws10}";
        "${super}+${mod1}+bracketleft" = "move container to workspace ${prev}; workspace ${prev}";
        "${super}+${mod1}+bracketright" = "move container to workspace ${next}; workspace ${next}";

        ## reload the configuration file
        "${super}+${mod2}+c" = "reload";
        ##  restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
        "${super}+${mod2}+r" = "restart";
      };
      # window.commands = [
      #   {
      #   criteria.class = "Pavucontrol";
      #   command = "floating enable sticky enable border normal";
      #   }
      #   {
      #   criteria.class = "Variety";
      #   command = "floating enable sticky enable border normal";
      #   }
      #   {
      #   criteria.class = "Lxappearance";
      #   command = "floating enable sticky enable border normal";
      #   }
      #   {
      #   criteria.class = "Nitrogen";
      #   command = "floating enable sticky enable border normal";
      #   }
      # ];

      bars = [
        {
          command = "i3bar";
          statusCommand = "i3status-rs";
          # trayOutput = tray;
          colors = with palette; {
            background = base00;
            separator = base01;
            statusline = base04;
            focusedWorkspace = {
              border = base05;
              background = base0D;
              text = base00;
            };
            activeWorkspace = {
              border = base05;
              background = base03;
              text = base00;
            };
            inactiveWorkspace = {
              border = base03;
              background = base01;
              text = base05;
            };
            urgentWorkspace = {
              border = base08;
              background = base08;
              text = base00;
            };
            bindingMode = {
              border = base00;
              background = base0A;
              text = base00;
            };
          };
        }
      ];
      #);
      colors = with palette; {
        background = base07;
        focused = {
          border = base05;
          background = base0D;
          text = base00;
          indicator = base0D;
          childBorder = base0C;
        };
        focusedInactive = {
          border = base01;
          background = base01;
          text = base05;
          indicator = base03;
          childBorder = base01;
        };
        unfocused = {
          border = base01;
          background = base00;
          text = base05;
          indicator = base01;
          childBorder = base01;
        };
        urgent = {
          border = base08;
          background = base08;
          text = base00;
          indicator = base08;
          childBorder = base08;
        };
        placeholder = {
          border = base00;
          background = base00;
          text = base05;
          indicator = base00;
          childBorder = base00;
        };
      };
    };
  };
}
