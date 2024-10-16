{lib, pkgs, ...}: let
  maps = import ../maps.nix {inherit lib;} ;
in {
  programs.nixvim = {
    keymaps = maps.nmap {"<leader>e" = [ ":Neotree toggle<cr>" {desc = "Toggle Explorer";} ]; };
    plugins.lazy.plugins = with pkgs.vimPlugins; [{
      pkg = neo-tree-nvim;
      opts = {
        window.position = "right";
        close_if_last_window = true;
      };
      dependencies = [
        plenary-nvim
        nvim-web-devicons
        image-nvim
        nui-nvim
        nvim-window-picker
      ];
    }];
  };
}
