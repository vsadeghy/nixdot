{pkgs, ...}: {
  imports = [
    ./neotree.nix
    ./base16.nix
    ./bufferline.nix
    ./lualine.nix
    ./treesitter.nix
    ./telescope.nix
    ./navbuddy.nix
    ./lsp.nix
    ./barbeque.nix
    ./none-ls.nix
    ./completions.nix
    ./gitsigns.nix
    ./indent-blankline.nix
    ./zen.nix
    ./noice.nix
    ./misc.nix
    ./hop.nix
    ./harpoon.nix
    ./term.nix
    ./tmux-navigator.nix
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
