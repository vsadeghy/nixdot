# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  pkgs,
  ...
}: let
  mirrors = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://mirror.sjtu.edu.cn/nix-channels/store"
  ];
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd = {
      # kernelModules = ["nvidia"];
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
    };
    supportedFilesystems = ["ntfs"];
    extraModulePackages = with config.boot.kernelPackages; [ddcci-driver];
    kernelModules = ["i2c-dev" "ddci-backlight"];
    kernelParams = ["module_blacklist=amdgpu"];
  };
  nix.settings = {
    substituters = mirrors;
    # trusted-public-keys = [
    #   "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    # ];
    trusted-substituters = mirrors;
    experimental-features = ["nix-command flakes"];
    use-xdg-base-directories = true;
    nix-path = config.nix.nixPath;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    configPackages = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal];
    config = {
      common.default = ["gtk"];
      "org.freedesktop.portal.Settings" = {};
    };
  };
  programs = {
    light = {
      enable = true;
      brightnessKeys = {
        enable = true;
        step = 10;
      };
    };
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 10";
      };
      flake = "/home/vss/.nixdot";
    };
    appimage.enable = true;
  };
  networking = {
    # firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;

    # Copy the NixOS configuration file and link it from the resulting system
    hostName = "vix";
    wireless = {
      enable = true;
      networks = {
        "vahid reyhane" = {
          pskRaw = "a5ff894e709c784c4b76eff13f46f532af2d44c8045745a5078319fc5d58d32d";
        };
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Configure network proxy if necessary
  # networking.proxy = let
  #   neko = "127.0.0.1:2081";
  # in {
  #   httpProxy = neko;
  #   httpsProxy = neko;
  #   noProxy = "127.0.0.1,localhost,internal.domain";
  # };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };
  security.polkit.enable = true;
  services = {
    # openssh.enable = true;
    pipewire = {
      enable = false;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    pulseaudio = {
      enable = true;
      support32Bit = true;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
    blueman.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    displayManager.defaultSession = "none+i3";
    xserver = {
      enable = true;
      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps;
          extraPackages = with pkgs; [
            dmenu
            rofi
            i3status
            i3status-rust
            i3lock-color
            xss-lock
            i3blocks
          ];
        };
      };

      xkb = {
        layout = "us,ir";
        options = "grp:shifts_toggle;caps:escape";
      };

      # videoDrivers = ["nvidia"];
    };

    kanata = {
      enable = true;
      keyboards = {
        homerow-extended = {
          extraDefCfg = ''
            process-unmapped-keys yes
            concurrent-tap-hold yes
            chords-v2-min-idle-experimental 50
          '';
          config = builtins.readFile ./kanata.kbd;
        };
      };
    };
  };

  hardware = {
    i2c.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
        vdpauinfo
        libva
        libva-utils
        libGL
        glxinfo
        mesa-demos
      #   nvtopPackages.full
      ];
    };
    nvidia = {
      # package = config.boot.kernelPackages.nvidiaPackages.production;
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vss = {
    isNormalUser = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    extraGroups = ["wheel" "networkmanager" "input" "video" "audio"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      alacritty
      brave
      nitrogen
      variety
      gh
      stow
      tlrc
      xorg.libxcb
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    noto-fonts-emoji
  ];
  environment = {
    pathsToLink = ["/share/zsh"];
    sessionVariables = rec {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_BIN_HOME = "$HOME/.local/bin";
      XDG_RUNTIME_DIR = "/run/user/$UID";
      PATH = [
        "${XDG_BIN_HOME}"
      ];
    };
    shells = with pkgs; [zsh];
    systemPackages = with pkgs; [
      obexftp
      android-file-transfer
      sshfs
      home-manager
      nix-output-monitor
      nvd
      wget
      vim
      git
      arandr
      lsof
      nekoray
      pciutils
      glxinfo
      nixos-option
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
