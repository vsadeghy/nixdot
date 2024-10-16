{lib, pkgs, ... }: {
  imports = [
    ./neotree.nix
    ./base16.nix
  ];
  programs.nixvim.plugins = {
    lazy = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        which-key-nvim
      ];
    };
  };
}

