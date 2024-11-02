{pkgs, ...}: {
  programs.nixvim.plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = nvim-navbuddy;
      dependencies = [nvim-navic nui-nvim comment-nvim];
      opts = {
        lsp.auto_attach = true;
        exclude_filetypes = ["netrw" "toggleterm"];
        icons = {
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
          Function      = "󰊕 ";
          Interface     = "󰕘 ";
          Key           = "󰌋 ";
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
