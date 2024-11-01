{
  pkgs,
  config,
  ...
}: let
  opt = mode: conf: (config.lib.nixvim.listToUnkeyedAttrs [mode]) // conf;
  mode = opt "mode" {
    fmt.__raw = ''
      function(str)
        return " " .. str--:sub(1, 1) -- only first character of the mode
      end
    '';
  };
  filename = opt "filename" {
    file_status = true;
    path = 0;
  };
  hide_in_width.__raw = ''
    function()
          return vim.fn.winwidth(0) > 100
    end
  '';
  diagnostics = opt "diagnostics" {
    sources = ["nvim_diagnostic"];
    sections = ["error" "warn"];
    symbols = {
      error = " ";
      warn = " ";
      info = " ";
      hint = " ";
    };
    colored = false;
    update_in_insert = false;
    always_visible = false;
    cond = hide_in_width;
  };
  diff = opt "diff" {
    colored = false;
    symbols = {
      added = " ";
      modified = " ";
      removed = " ";
    };
    cond = hide_in_width;
  };
in {
  programs.nixvim.plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = lualine-nvim;
      opts = {
        options = {
          icons_enabled = true;
          theme = "base16";
          # --        
          section_separators = {
            left = "";
            right = "";
          };
          component_separators = {
            left = "";
            right = "";
          };
          disabled_filetypes = ["alpha" "neo-tree"];
          always_divide_middle = true;
        };
        sections = {
          lualine_a = [mode];
          lualine_b = ["branch"];
          lualine_c = [filename];
          lualine_x = [
            diagnostics
            diff
            (opt "encoding" {cond = hide_in_width;})
            (opt "filetype" {cond = hide_in_width;})
          ];
          lualine_y = ["location"];
          lualine_z = ["progress"];
        };
        inactive_sections = {
          lualine_a = [];
          lualine_b = [];
          lualine_c = [(opt "filename" {path = 1;})];
          lualine_x = [(opt "location" {padding = 0;})];
          lualine_y = [];
          lualine_z = [];
        };
      };
    }
  ];
}
