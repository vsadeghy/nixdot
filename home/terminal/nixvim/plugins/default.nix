{pkgs, ...}: {
  imports = [
    ./neotree.nix
    ./base16.nix
    ./treesitter.nix
    ./telescope.nix
    ./lsp.nix
    ./none-ls.nix
    ./completions.nix
    ./gitsigns.nix
    ./indent-blankline.nix
    ./misc.nix
    ./hop.nix
  ];
  programs.nixvim.plugins = {
    lazy = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];
    };
  };
}
