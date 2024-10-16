{lib, pkgs, ... }: {
  imports = [
    ./neotree.nix
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

