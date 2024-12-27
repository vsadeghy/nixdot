{config, ...}: let
  palette = builtins.mapAttrs (_: color: "#" + color) config.colorScheme.palette;
in {
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
    extraConfig = with palette; ''
      # Transparency
      # background_opacity 0.7
      # dynamic_background_opacity true

      # base16 colors
      background ${base00}
      foreground ${base05}
      selection_background ${base00}
      selection_foreground ${base06}
      url_color ${base06}
      cursor  ${base06}
      cursor_text_color ${base00}
      active_border_color ${base07}
      inactive_border_color ${base04}
      active_tab_background   ${base02}
      active_tab_foreground   ${base0E}
      active_tab_font_style   bold
      inactive_tab_foreground ${base05}
      inactive_tab_background ${base01}
      inactive_tab_font_style bold
      tab_bar_background ${base00}
      bell_border_color ${base0A}
      tab_bar_style fade
      tab_fade 1

      # normal
      color0  ${base00}
      color1  ${base08}
      color2  ${base0B}
      color3  ${base0A}
      color4  ${base0D}
      color5  ${base0E}
      color6  ${base0C}
      color7  ${base05}

      # bright
      color8  ${base03}
      color9  ${base09}
      color10 ${base01}
      color11 ${base02}
      color12 ${base04}
      color13 ${base06}
      color14 ${base0F}
      color14 ${base07}
    '';
  };
}
