{
  inputs,
  pkgs,
  config,
  ...
}: let
  palette = builtins.mapAttrs (_: color: "#" + color) config.colorScheme.palette;
in {
  home = {
    packages = [inputs.ghostty.packages."${pkgs.system}".default];
    file.ghostty = {
      target = ".config/ghostty/config";
      text = with palette; ''
        font-family = "JetBrains Mono Nerd Font"
        font-size = 14
        window-decoration = server
        shell-integration-features = true
        confirm-close-surface = false
        # initial-command = "tmux a || tmux || $SHELL"
        background = ${base00}
        foreground = ${base05}

        selection-background = ${base02}
        selection-foreground = ${base00}

        palette = 0=${base00}
        palette = 1=${base08}
        palette = 2=${base0B}
        palette = 3=${base0A}
        palette = 4=${base0D}
        palette = 5=${base0E}
        palette = 6=${base0C}
        palette = 7=${base05}

        palette = 8=${base03}
        palette = 9=${base09}
        palette = 10=${base01}
        palette = 11=${base02}
        palette = 12=${base04}
        palette = 13=${base06}
        palette = 14=${base0F}
        palette = 15=${base07}

        keybind = alt+1=unbind
        keybind = alt+2=unbind
        keybind = alt+3=unbind
        keybind = alt+4=unbind
        keybind = alt+5=unbind
        keybind = alt+6=unbind
        keybind = alt+7=unbind
        keybind = alt+8=unbind
        keybind = alt+0=unbind
      '';
    };
  };
}
