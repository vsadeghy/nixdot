{lib, pkgs, ... }: {
  imports = [
    ./neotree.nix
    ./treesitter.nix
    ./base16.nix
    ./lsp.nix
  ];
  programs.nixvim.plugins = {
    lazy = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        which-key-nvim
        vim-nix
      ];
    };
  };
}

