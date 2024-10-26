{config, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };
    shellIntegration.enableZshIntegration = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      window_background_opacity = "0.7";
      dim_opacity = "0.75";
      disable_ligatures = false;
      enable_audio_bell = true;
    };
    extraConfig = with config.colorScheme.palette; ''
      # Transparency
      # background_opacity 0.7
      # dynamic_background_opacity true
      # base16 colors
      background #${base00}
      foreground #${base05}
      selection_background #${base0D}
      selection_foreground #${base01}
      url_color #${base0C}
      cursor  #${base07}
      cursor_text_color #${base00}
      active_border_color #${base04}
      inactive_border_color #${base00}
      active_tab_background   #${base00}
      active_tab_foreground   #${base04}
      active_tab_font_style   bold
      inactive_tab_foreground #${base07}
      inactive_tab_background #${base08}
      inactive_tab_font_style bold
      tab_bar_background #${base00}
      bell_border_color #${base03}
      tab_bar_style fade
      tab_fade 1

      # normal
      color0  #${base03}
      color1  #${base08}
      color2  #${base0B}
      color3  #${base09}
      color4  #${base0D}
      color5  #${base0E}
      color6  #${base0C}
      color7  #${base06}

      # bright
      color8  #${base04}
      color9  #${base08}
      color10 #${base0B}
      color11 #${base0A}
      color12 #${base0C}
      color13 #${base0E}
      color14 #${base0C}
      color15 #${base07}

      # extended base16 colors
      color16 #${base00}
      color17 #${base0F}
      color18 #${base0B}
      color19 #${base09}
      color20 #${base0D}
      color21 #${base0E}
      color22 #${base0C}
      color23 #${base06}
    '';
  };
}
