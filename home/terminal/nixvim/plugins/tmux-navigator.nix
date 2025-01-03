{
  pkgs,
  lib,
  ...
}: let
  inherit (import ../maps.nix {inherit lib;}) nmap;
in {
  programs.nixvim = {
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        pkg = vim-tmux-navigator;
      }
    ];
    keymaps = nmap {
      "<c-l>" = ["<cmd>TmuxNavigateLeft<cr>" "Navigate left"];
      "<c-h>" = ["<cmd>TmuxNavigateUp<cr>" "Navigate up"];
      "<c-j>" = ["<cmd>TmuxNavigateDown<cr>" "Navigate down"];
      "<c-k>" = ["<cmd>TmuxNavigateRight<cr>" "Navigate right"];
    };
  };
}
