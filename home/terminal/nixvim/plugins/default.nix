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
  ];
  programs.nixvim.plugins = {
    lazy = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        which-key-nvim
        vim-nix
        {
          pkg = nvim-autopairs;
          event = "InsertEnter";
          config = true;
          opts = {};
        }
      ];
    };
  };
}
