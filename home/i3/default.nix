{
  pkgs,
  config,
  ...
}: let
  mod = "Mod4";
  alt = "Mod1";
  browser = "zen";
  terminal = "kitty";
  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";
  ws7 = "7";
  ws8 = "8";
  ws9 = "0";
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
      modifier = mod;
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
        # { command = "nitrogen --restore"; }
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
      keycodebindings = {
        "${mod}+Shift+40" = ''exec "rofi -modi drun,run -show drun"'';
      };
      keybindings = {
        ## main
        "${mod}+Return" = "exec ${terminal}";
        "${mod}+d" = "exec --no-startup-id dmenu_run";
        "${mod}+q" = "kill";

        ## modes
        "${mod}+x" = ''mode "${mode_system}"'';
        "${mod}+g" = ''mode "${mode_gaps}"'';
        "${mod}+r" = ''mode "resize"'';

        ## borders
        "${mod}+u" = "border none";
        "${mod}+y" = "border pixel 1";
        "${mod}+n" = "border normal";

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
        "${mod}+b" = "exec ${browser}";

        ## split orientation
        #"${mod}+h" = "split h;exec notify-send 'tile horizontally'";
        #"${mod}+v" = "split v;exec notify-send 'tile vertically'";
        "${mod}+semicolon" = "split toggle";

        #enter fullscreen mode for the focused container
        "${mod}+f" = "fullscreen toggle";

        #change container layout (stacked, tabbed, toggle split)
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+shift+semicolon" = "layout toggle split";

        ## toggle tiling / floating
        "${mod}+Shift+space" = "floating toggle";

        ## change focus between tiling / floating windows
        "${mod}+space" = "focus mode_toggle";

        ## toggle sticky
        "${mod}+Shift+s" = "sticky toggle";

        ## focus the parent container
        "${mod}+a" = "focus parent";

        ## move the currently focused window to the scratchpad
        "${mod}+Shift+minus" = "move scratchpad";

        ## Show the next scratchpad window or hide the focused scratchpad window.
        ## If there are multiple scratchpad windows, this command cycles through them.
        "${mod}+minus" = "scratchpad show";

        ## switch to workspace
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";
        "${mod}+o" = "workspace back_and_forth";
        "${mod}+1" = "workspace number ${ws1}";
        "${mod}+2" = "workspace number ${ws2}";
        "${mod}+3" = "workspace number ${ws3}";
        "${mod}+4" = "workspace number ${ws4}";
        "${mod}+5" = "workspace number ${ws5}";
        "${mod}+6" = "workspace number ${ws6}";
        "${mod}+7" = "workspace number ${ws7}";
        "${mod}+8" = "workspace number ${ws8}";
        "${mod}+9" = "workspace number ${ws9}";
        "${mod}+0" = "workspace number ${ws10}";
        "${mod}+bracketleft" = "workspace ${prev}";
        "${mod}+bracketright" = "workspace ${next}";

        ## move focused container to workspace
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";
        "${mod}+Shift+o" = "move container to workspace back_and_forth";
        "${mod}+Shift+1" = "move container to workspace number ${ws1}";
        "${mod}+Shift+2" = "move container to workspace number ${ws2}";
        "${mod}+Shift+3" = "move container to workspace number ${ws3}";
        "${mod}+Shift+4" = "move container to workspace number ${ws4}";
        "${mod}+Shift+5" = "move container to workspace number ${ws5}";
        "${mod}+Shift+6" = "move container to workspace number ${ws6}";
        "${mod}+Shift+7" = "move container to workspace number ${ws7}";
        "${mod}+Shift+8" = "move container to workspace number ${ws8}";
        "${mod}+Shift+9" = "move container to workspace number ${ws9}";
        "${mod}+Shift+0" = "move container to workspace number ${ws10}";
        "${mod}+Shift+bracketleft" = "move container to workspace ${prev}";
        "${mod}+Shift+bracketright" = "move container to workspace ${next}";

        ## move focused container to workspace and switch to it
        "${mod}+${alt}+h" = "move left; focus left";
        "${mod}+${alt}+j" = "move down; focus down";
        "${mod}+${alt}+k" = "move up; focus up";
        "${mod}+${alt}+l" = "move right; focus right";
        "${mod}+${alt}+Left" = "move left; focus left";
        "${mod}+${alt}+Down" = "move down; focus down";
        "${mod}+${alt}+Up" = "move up; focus up";
        "${mod}+${alt}+Right" = "move right; focus right";
        "${mod}+${alt}+o" = "move container to workspace back_and_forth; workspace back_and_forth";
        "${mod}+${alt}+1" = "move container to workspace number ${ws1}; workspace number ${ws1}";
        "${mod}+${alt}+2" = "move container to workspace number ${ws2}; workspace number ${ws2}";
        "${mod}+${alt}+3" = "move container to workspace number ${ws3}; workspace number ${ws3}";
        "${mod}+${alt}+4" = "move container to workspace number ${ws4}; workspace number ${ws4}";
        "${mod}+${alt}+5" = "move container to workspace number ${ws5}; workspace number ${ws5}";
        "${mod}+${alt}+6" = "move container to workspace number ${ws6}; workspace number ${ws6}";
        "${mod}+${alt}+7" = "move container to workspace number ${ws7}; workspace number ${ws7}";
        "${mod}+${alt}+8" = "move container to workspace number ${ws8}; workspace number ${ws8}";
        "${mod}+${alt}+9" = "move container to workspace number ${ws9}; workspace number ${ws9}";
        "${mod}+${alt}+0" = "move container to workspace number ${ws10}; workspace number ${ws10}";
        "${mod}+${alt}+bracketleft" = "move container to workspace ${prev}; workspace ${prev}";
        "${mod}+${alt}+bracketright" = "move container to workspace ${next}; workspace ${next}";

        ## reload the configuration file
        "${mod}+Shift+c" = "reload";
        ##  restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
        "${mod}+Shift+r" = "restart";
        ## exit i3 (logs you out of your X session)
        "${mod}+Shift+e" = ''exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"'';
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
