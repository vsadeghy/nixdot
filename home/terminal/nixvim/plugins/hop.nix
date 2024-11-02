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
      s = [":HopCamelCaseMW<cr>"];
      S = [":HopChar2MW<cr>"];
      f = [":HopChar1CurrentLineAC<cr>"];
      F = [":HopChar1CurrentLineBC<cr>"];
      "<leader>j" = ["<nop>" {desc = "Jump";}];
      "<leader>jw" = [":HopWordMW<cr>" {desc = "Jump Word";}];
      "<leader>jl" = [":HopLineStartMW<cr>" {desc = "Jump Line ^";}];
      "<leader>jL" = [":HopLineMW<cr>" {desc = "Jump Line 0";}];
      "<leader>j/" = [":HopAnywhereMW<cr>" {desc = "Find Char";}];
      "<leader>jf" = [":HopChar1CurrentLineAC<cr>" {desc = "Find Forwards";}];
      "<leader>jF" = [":HopChar1CurrentLineBC<cr>" {desc = "Find Backwards";}];
      "<leader>jy" = [":HopYankChar1MW<cr>" {desc = "Yank";}];
      "<leader>jp" = [":HopPasteChar1MW<cr>" {desc = "Paste";}];
    };
  };
}
