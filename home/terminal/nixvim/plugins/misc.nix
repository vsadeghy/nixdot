{pkgs, ...}: {
  programs.nixvim.plugins.lazy.plugins = with pkgs.vimPlugins; [
    which-key-nvim
    {
      pkg = todo-comments-nvim;
      opts.signs = false;
    }
    {
      pkg = nvim-colorizer-lua;
      config = true;
    }
    {
      pkg = nvim-autopairs;
      event = "InsertEnter";
      config = true;
      opts = {};
    }
    {
      pkg = lsp_lines-nvim;
      config = true;
      init.__raw = ''
        function()
          vim.diagnostic.config {
            virtual_text = false,
            update_in_insert = false,
          }
          vim.diagnostic.open_float()
        end
      '';
    }
  ];
}
