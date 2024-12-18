{config, ...}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    colorSchemes.base16 = let
      colors = builtins.mapAttrs (_: color: "#" + color) config.colorScheme.palette;
    in
      with colors; {
        background = base00;
        foreground = base05;

        cursor_bg = base00;
        cursor_border = base05;
        cursor_fg = base00;

        selection_bg = base05;
        selection_fg = base00;
        ansi = [base00 base08 base0B base0A base0D base0E base0C base05];
        brights = [base03 base09 base01 base02 base04 base06 base0F base07];
      };
  };
}
