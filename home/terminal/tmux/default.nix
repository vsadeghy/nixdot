{pkgs, ...}: let
  inherit (import ./tmux-sessionizer.nix {inherit pkgs;}) tmux-sessionizer;
in {
  home.packages = [tmux-sessionizer];
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      vim-tmux-navigator
    ];
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    extraConfig = ''
      #!/bin/sh
      set-option -sa terminal-overrides ",xterm*:Tc"
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi C-v send -X rectangle-toggle
      bind-key -T copy-mode-vi y send -X copy-selection-and-cancel
      bind-key -T copy-mode-vi M send -X reverse-search-history
      bind h split-window -h -c "#{pane_current_path}"
      bind v split-window -v -c "#{pane_current_path}"
      bind f resize-pane -Z

      bind-key f run-shell "tmux neww tmux-sessionizer"

      source-file ~/.tmux.conf
      bind-key r source-file ~/.tmux.conf
    '';
  };
}
