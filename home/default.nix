{
  pkgs,
  inputs,
  ...
}: let
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "peach";
  };
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./terminal
    ./i3
  ];
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
  fonts.fontconfig.enable = true;
  inherit catppuccin;
  services = {
    mpris-proxy.enable = true;
    udiskie.enable = true;
    playerctld.enable = true;
    flameshot = {
      enable = true;
      settings = {
        General = {
          showHelp = false;
          startupLaunch = true;
        };
      };
    };
  };
  gtk = {
    enable = true;
    # theme.packages = pkgs.catppuccin-gtk.override {
    #   accents = ["mauve"];
    #   variant = "macchiato";
    #   size = "standard";
    # };
    # theme.name = "Catppuccin-Dark";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
    };
  };
  home = {
    username = "vss";
    homeDirectory = "/home/vss";
    stateVersion = "24.05";
    packages = with pkgs; [
      xsel
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      htop
      firefox
      zenith
      nix-top
      unzip
      ripgrep
      ueberzug
      chafa
      imagemagick
      ffmpeg
      ffmpegthumbnailer
      # libjpeg
      pcmanfm
      pavucontrol
      file-roller
      unrar
      obsidian
      lxappearance
      lazygit
      libsForQt5.qt5ct

      ytmdesktop
      youtube-music
      ferdium
      jdk23
      # (catppuccin-gtk.override {
      #   accents = ["rosewater"];
      #   variant = "macchiato";
      # })
      # (magnetic-catppuccin-gtk.override {
      #   accent = ["all"];
      #   tweaks = ["macchiato" "mocha"];
      #   shade = "dark";
      # })
      # magnetic-catppuccin-gtk
      catppuccin-qt5ct
      mpv
      sshfs
      dconf
      gpick
      xdotool
      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
      inputs.zen-browser.packages."${pkgs.system}".specific
      vesktop
      spotube
      qbittorrent-enhanced

      libqalculate
      galculator

      xorg.xkill
      xorg.xbacklight
      brightnessctl
      ddcutil

      insomnia
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

      nekoRayRouting = {
        target = ".config/nekoray/config/routes/Default";
        text = builtins.toJSON {
          block_domain = ''
            geosite:category-ads-all
            domain:appcenter.ms
            domain:firebase.io
            domain:crashlytics.com
            domain:google-analytics.com
          '';
          custom.rules = [
            {
              outboundTag = "direct";
              protocol = ["bittorrent"];
              type = "field";
            }
          ];
          def_outbound = "proxy";
          direct_dns = "localhost";
          direct_domain = ''
            regexp:^.+\.ir$
            geosite:category-ir
            maryammobaraki.net
            github.com
          '';
          direct_ip = "geoip:ir";
          dns_final_out = "proxy";
          dns_routing = true;
          domain_strategy = "IPIfNonMatch";
          outbound_domain_strategy = "PreferIPv4";
          remote_dns = "https://1.1.1.1/dns-query";
          sniffing_mode = 1;
          use_dns_object = false;
        };
      };
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
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_BIN_HOME = "$HOME/.local/bin";

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
