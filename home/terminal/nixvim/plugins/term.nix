{
  pkgs,
  lib,
  ...
}: let
  inherit (import ../maps.nix {inherit lib;}) mkMap;
in {
  programs.nixvim = {
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      FTerm-nvim
      toggleterm-nvim
    ];
    keymaps = mkMap ["n" "i" "t"] {
      "<A-t>" = ["<cmd>lua require('FTerm').toggle()<CR>" "Toggle terminal"];
    };
  };
}
