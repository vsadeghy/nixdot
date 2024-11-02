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
        pkg = zen-mode-nvim;
        dependencies = [twilight-nvim];
        opts = {
          plugins.gitsigns.enabled = true;
          on_open.__raw = ''
            function(_) require("barbecue.ui").toggle(false) end
          '';
          on_close.__raw = ''
            function(_) require("barbecue.ui").toggle(true) end
          '';
        };
      }
    ];
    keymaps = nmap {
      "<leader>tz" = ["<cmd>ZenMode<cr>" "Zen Mode"];
    };
  };
}
