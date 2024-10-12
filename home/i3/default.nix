{ pkgs, config, ...}: let
  mod = "Mod4";
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
  refresh_i3status  = "killall -SIGUSR1 i3status";

  mode_system = "(l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown";
  mode_gaps = "Gaps: (o) outer, (i) inner";
  mode_gaps_outer = "Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)";
  mode_gaps_inner = "Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)";
   
in {
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
        criteria = [
          { class = "Pavucontrol"; }
          { class = "Variety"; }
          { class = "Lxappearance"; }
          { class = "Nitrogen"; }
        ];
      };
      startup = [
        { command = "xrandr --output HDMI-1 --auto --left-of --DP-1"; }
        { command = "xss-lock --transfer-sleep-lock -- i3lock-color --nofork"; }
        # { command = "nitrogen --restore"; }
        # { command = "clipit"; }
        # { command = "pcmanfm -d"; }
        # { command = "xautolock -time 10 -locker i3lock"; }
      ];
      modes = {
        ${mode_system} = {
          l         = "exec --no-startup-id i3lock             , mode default";
          s         = "exec --no-startup-id systemctl suspend  , mode default";
          u         = "exec --no-startup-id i3exit switch_user , mode default";
          e         = "exec --no-startup-id i3-msg exit        , mode default";
          h         = "exec --no-startup-id systemctl hibernate, mode default";
          r         = "exec --no-startup-id systemctl reboot   , mode default";
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
          o      = ''mode "${mode_gaps_outer}"'';
          i      = ''mode "${mode_gaps_inner}"'';
          Return = "mode default";
          Escape = "mode default";
        };
        ${mode_gaps_inner} = {
          plus    = "gaps inner current plus 5";
          minus   = "gaps inner current minus 5";
          "0"     = "gaps inner current set 0";
        
          "Shift+plus"  = "gaps inner all plus 5";
          "Shift+minus" = "gaps inner all minus 5";
          "Shift+0"     = "gaps inner all set 0";
        
          Return = "mode default";
          Escape = "mode default";
        };
        "${mode_gaps_outer}" = {
          plus    = "gaps outer current plus 5";
          minus   = "gaps outer current minus 5";
          "0"     = "gaps outer current set 0";
        
          "Shift+plus"  = "gaps outer all plus 5";
          "Shift+minus" = "gaps outer all minus 5";
          "Shift+0"     = "gaps outer all set 0";
        
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
        "${mod}+shift+q" = "kill";

        ## modes
        "${mod}+0" = ''mode "${mode_system}"'';
        "${mod}+g" = ''mode "${mode_gaps}"'';
        "${mod}+r" = ''mode "resize"'';

        ## borders
        "${mod}+u" = "border none";
        "${mod}+y" = "border pixel 1";
        "${mod}+n" = "border normal";
        
        ## multimedia
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@   +10%   && ${refresh_i3status}";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@   -10%   && ${refresh_i3status}";
        "XF86AudioMute"        = "exec --no-startup-id pactl set-sink-mute   @DEFAULT_SINK@   toggle && ${refresh_i3status}";
        "XF86AudioMicMute"     = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && ${refresh_i3status}";
        
        ## launcher
        "${mod}+b" = "exec ${browser}";
        
        ## change focus
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        
        ## move focused window
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        
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
        
        ## workspace back and forth (with/without active container)
        "${mod}+o"       = "workspace back_and_forth";
        "${mod}+Ctrl+o"  = "move container to workspace back_and_forth;";
        "${mod}+Shift+o" = "move container to workspace back_and_forth; workspace back_and_forth";
        
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
        "${mod}+1" = "workspace number ${ws1}";
        "${mod}+2" = "workspace number ${ws2}";
        "${mod}+3" = "workspace number ${ws3}";
        "${mod}+4" = "workspace number ${ws4}";
        "${mod}+5" = "workspace number ${ws5}";
        "${mod}+6" = "workspace number ${ws6}";
        "${mod}+7" = "workspace number ${ws7}";
        "${mod}+8" = "workspace number ${ws8}";
        
        ## move focused container to workspace
        "${mod}+Shift+1" = "move container to workspace number ${ws1}";
        "${mod}+Shift+2" = "move container to workspace number ${ws2}";
        "${mod}+Shift+3" = "move container to workspace number ${ws3}";
        "${mod}+Shift+4" = "move container to workspace number ${ws4}";
        "${mod}+Shift+5" = "move container to workspace number ${ws5}";
        "${mod}+Shift+6" = "move container to workspace number ${ws6}";
        "${mod}+Shift+7" = "move container to workspace number ${ws7}";
        "${mod}+Shift+8" = "move container to workspace number ${ws8}";

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

      bars = let
      # bar = { tray }: {
      bar = {
        command = "i3bar";
        statusCommand = "i3status-rs";
        # trayOutput = tray;
        trayOutput = "DP-1";
        colors = with config.colorScheme.palette; {
          background = "#${base00}";
          separator  = "#${base01}";
          statusline = "#${base04}";
          focusedWorkspace = {
            border      = "#${base05}";
            background  = "#${base0D}";
            text        = "#${base00}";
          };
          activeWorkspace = {
            border      = "#${base05}";
            background  = "#${base03}";
            text        = "#${base00}";
          };
          inactiveWorkspace = {
            border      = "#${base03}";
            background  = "#${base01}";
            text        = "#${base05}";
          };
          urgentWorkspace = {
            border      = "#${base08}";
            background  = "#${base08}";
            text        = "#${base00}";
          };
          bindingMode = {
            border      = "#${base00}";
            background  = "#${base0A}";
            text        = "#${base00}";
          };
        };
      }; in [
        bar
        # bar { tray = "primary"; }
        # bar { tray = "DP-1"; }
      ];
      colors = with config.colorScheme.palette; {
        background    = "#${base07}";
        focused = {
          border      = "#${base05}";
          background  = "#${base0D}";
          text        = "#${base00}";
          indicator   = "#${base0D}";
          childBorder = "#${base0C}";
        };
        focusedInactive = {
          border      = "#${base01}";
          background  = "#${base01}";
          text        = "#${base05}";
          indicator   = "#${base03}";
          childBorder = "#${base01}";
        };
        unfocused = {
          border      = "#${base01}";
          background  = "#${base00}";
          text        = "#${base05}";
          indicator   = "#${base01}";
          childBorder = "#${base01}";
        };
        urgent = {
          border      = "#${base08}";
          background  = "#${base08}";
          text        = "#${base00}";
          indicator   = "#${base08}";
          childBorder = "#${base08}";
        };
        placeholder = {
          border      = "#${base00}";
          background  = "#${base00}";
          text        = "#${base05}";
          indicator   = "#${base00}";
          childBorder = "#${base00}";
        };
      };
    };
  };
}
