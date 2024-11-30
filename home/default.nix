{
  pkgs,
  inputs,
  ...
}: let
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "rosewater";
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
  };
  home = {
    username = "vss";
    homeDirectory = "/home/vss";
    stateVersion = "24.05";
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "JetBrainsMono"];})
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
      catppuccin-gtk
      magnetic-catppuccin-gtk
      catppuccin-qt5ct
      mpv
      sshfs
      dconf
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
