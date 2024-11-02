{
  lib,
  pkgs,
  ...
}: let
  inherit (import ../maps.nix {inherit lib;}) nmap;
in {
  programs.nixvim = {
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        pkg = hop-nvim;
        dependencies = [repeat];
        config = true;
      }
    ];
    keymaps = nmap {
      s = ["<cmd>HopCamelCaseMW<cr>"];
      S = ["<cmd>HopChar2MW<cr>"];
      f = ["<cmd>HopChar1CurrentLineAC<cr>"];
      F = ["<cmd>HopChar1CurrentLineBC<cr>"];
      "<leader>j" = ["<nop>" "Jump"];
      "<leader>jw" = ["<cmd>HopWordMW<cr>" "Jump Word"];
      "<leader>jl" = ["<cmd>HopLineStartMW<cr>" "Jump Line ^"];
      "<leader>jL" = ["<cmd>HopLineMW<cr>" "Jump Line 0"];
      "<leader>j/" = ["<cmd>HopAnywhereMW<cr>" "Find Char"];
      "<leader>jf" = ["<cmd>HopChar1CurrentLineAC<cr>" "Find Forwards"];
      "<leader>jF" = ["<cmd>HopChar1CurrentLineBC<cr>" "Find Backwards"];
      "<leader>jy" = ["<cmd>HopYankChar1MW<cr>" "Yank"];
      "<leader>jp" = ["<cmd>HopPasteChar1MW<cr>" "Paste"];
    };
  };
}
