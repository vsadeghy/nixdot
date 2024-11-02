{pkgs, ...}: {
  programs.nixvim.plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = barbecue-nvim;
      dependencies = [nvim-navic base16-nvim];
      config.__raw = ''
        function()
          local bg = require('base16-colorscheme').colors.base00;
          require("barbecue").setup({
            exclude_filetypes = {"netrw", "toggleterm"},
            symbols = { separator = "" }, -- ""
            theme = { normal = { bg = bg } },
            kinds = {
              Array         = "󰅪 ",
              Boolean       = "◩ ",
              Class         = "󰌗 ",
              Constant      = "󰏿 ",
              Constructor   = " ",
              Enum          = "󰕘 ",
              EnumMember    = " ",
              Event         = " ",
              Field         = " ",
              File          = "󰈙 ",
              Folder        = "󰉋 ",
              Function      = "󰊕 ",
              Interface     = "󰕘 ",
              Keyword       = "󰌋 ",
              Method        = "m ",
              Module        = " ",
              Namespace     = "󰌗 ",
              Null          = "󰟢 ",
              Number        = " ",
              Object        = "󰅩 ",
              Operator      = "󰆕 ",
              Package       = " ",
              Property      = " ",
              String        = "󰉿 ",
              Struct        = "󰌗 ",
              TypeParameter = "󰊄 ",
              Variable      = "󰆧 ",
            },
          })
        end
      '';
    }
  ];
}
