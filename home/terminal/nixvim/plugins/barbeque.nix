{pkgs, ...}: {
  programs.nixvim.plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = barbecue-nvim;
      dependencies = [nvim-navic];
      opts = {
        exclude_filetypes = ["netrw" "toggleterm"];
        symbols.separator = ""; # ""
        kinds = {
          Array         = "󰅪 ";
          Boolean       = "◩ ";
          Class         = "󰌗 ";
          Constant      = "󰏿 ";
          Constructor   = " ";
          Enum          = "󰕘 ";
          EnumMember    = " ";
          Event         = " ";
          Field         = " ";
          File          = "󰈙 ";
          Folder        = "󰉋 ";
          Function      = "󰊕 ";
          Interface     = "󰕘 ";
          Keyword       = "󰌋 ";
          Method        = "m ";
          Module        = " ";
          Namespace     = "󰌗 ";
          Null          = "󰟢 ";
          Number        = " ";
          Object        = "󰅩 ";
          Operator      = "󰆕 ";
          Package       = " ";
          Property      = " ";
          String        = "󰉿 ";
          Struct        = "󰌗 ";
          TypeParameter = "󰊄 ";
          Variable      = "󰆧 ";
        };
      };
    }
  ];
}
