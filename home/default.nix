{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./terminal
    ./i3
  ];
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
  fonts.fontconfig.enable = true;
  home = {
    username = "vss";
    homeDirectory = "/home/vss";
    stateVersion = "24.05";
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
      unzip
      unrar
      obsidian
      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
      inputs.zen-browser.packages."${pkgs.system}".specific
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/vss/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = rec {
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_STATE_HOME  = "$HOME/.local/state";
      XDG_BIN_HOME    = "$HOME/.local/bin";

      EDITOR = "nvim";
      VOLTA_HOME = "${XDG_CONFIG_HOME}/volta";
      # PATH = [
      #   "${VOLTA_HOME}"
      #   "${XDG_BIN_HOME}"
      # ];
    };
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
  };
}
