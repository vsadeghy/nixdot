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
        pkg = noice-nvim;
        event = "VeryLazy";
        dependencies = [nui-nvim nvim-notify];
        opts = {
          overrride = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          presets = {
            bottom_search = false;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = true;
            lsp_doc_border = false;
          };
        };
      }
    ];
    keymaps = nmap {"<leader>n" = ["<cmd>Noice dismiss<cr>" {desc = "close notifications";}];};
  };
}
