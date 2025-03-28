{pkgs, ...}: let
  inherit (import ./tmux-sessionizer.nix {inherit pkgs;}) tmux-sessionizer;
in {
  home.packages = [tmux-sessionizer];
  home.file = {
    ".config/tmux/plugins/catppuccin/tmux" = {
      source = builtins.fetchGit {
        url = "https://github.com/catppuccin/tmux";
        rev = "2c4cb5a07a3e133ce6d5382db1ab541a0216ddc7";
      };
    };
    ".config/tmux/plugins/floax" = {
      source = builtins.fetchGit {
        url = "https://github.com/omerxx/tmux-floax";
        rev = "61c7f466b9a4ceed56f99d403250164170d586cd";
      };
    };
  };
  programs.tmux = {
    enable = true;
    prefix = "M-Space";
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      # catppuccin
      # tmux-floax
    ];
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    extraConfig =
      /*
      sh
      */
      ''
        # set-option -sa terminal-overrides ",xterm*:Tc"

        set -g default-terminal "xterm-256color"

        set -g @catppuccin_flavor "macchiato"
        set -g @catppuccin_window_text "#W"
        set -g @catppuccin_window_current_text "#W"
        set -g @floax-bind "-n M-t"
        # set -g @catppuccin_window_status_style "rounded"
        run "~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux"
        run "~/.config/tmux/plugins/floax/floax.tmux"
        set -g status-right ""

        bind s split-window -h -c "#{pane_current_path}"
        bind v split-window -v -c "#{pane_current_path}"
        bind -n M-Enter resize-pane -Z

        set -g renumber-windows on
        bind -n M-1 select-window -t 1
        bind -n M-2 select-window -t 2
        bind -n M-3 select-window -t 3
        bind -n M-4 select-window -t 4
        bind -n M-5 select-window -t 5
        bind -n M-6 select-window -t 6
        bind -n M-7 select-window -t 7
        bind -n M-8 select-window -t 8
        bind -n M-9 select-window -t 9
        bind -n M-0 select-window -t 10
        bind -n M-n select-window -n
        bind -n M-p select-window -p
        bind -n M-i switch-client -p
        bind -n M-o switch-client -n
        bind -n M-c new-window

        bind-key -T copy-mode-vi v send -X begin-selection
        bind-key -T copy-mode-vi C-v send -X rectangle-toggle
        bind-key -T copy-mode-vi y send -X copy-selection-and-cancel
        bind-key -T copy-mode-vi M send -X reverse-search-history

        bind f run-shell "tmux neww tmux-sessionizer"


        version_pat='s/^tmux[^0-9]*([.0-9]+).*/\1/p'

        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
        bind-key -n M-h if-shell "$is_vim" "send-keys M-h" "select-pane -L"
        bind-key -n M-j if-shell "$is_vim" "send-keys M-j" "select-pane -D"
        bind-key -n M-k if-shell "$is_vim" "send-keys M-k" "select-pane -U"
        bind-key -n M-l if-shell "$is_vim" "send-keys M-l" "select-pane -R"
        tmux_version="$(tmux -V | sed -En "$version_pat")"
        setenv -g tmux_version "$tmux_version"

        if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
        if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

        bind-key -T copy-mode-vi M-h select-pane -L
        bind-key -T copy-mode-vi M-j select-pane -D
        bind-key -T copy-mode-vi M-k select-pane -U
        bind-key -T copy-mode-vi M-l select-pane -R
        bind-key -T copy-mode-vi M-\\ select-pane -l

        source-file ~/.tmux.conf
        bind r source-file ~/.tmux.conf
      '';
  };
}
