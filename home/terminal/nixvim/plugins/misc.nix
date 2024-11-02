{pkgs, ...}: let
  ts-node-action = pkgs.vimUtils.buildVimPlugin {
    name = "ts-node-action";
    src = pkgs.fetchFromGitHub {
      owner = "CKolkey";
      repo = "ts-node-action";
      rev = "6d3b60754fd87963d70eadaa2f77873b447eac26";
      sha256 = "kOXH3r+V+DAxoATSnZepEAekrkO1TezKSkONuQ3Kzu4=";
    };
  };
in {
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
    {
      pkg = nvim-surround;
      dependencies = [nvim-treesitter nvim-treesitter-textobjects];
      event = "VeryLazy";
      opts = {};
      config = true;
    }
    dressing-nvim
    {
      pkg = neogit;
      dependencies = [diffview-nvim];
      config = true;
    }
    {
      pkg = neoscroll-nvim;
      config = true;
    }
    {
      pkg = numb-nvim;
      opts = {
        show_numbers = true; # Enable 'number' for the window while peeking
        show_cursorline = true; # Enable 'cursorline' for the window while peeking
        hide_relativenumbers = true; # Enable turning off 'relativenumber' for the window while peeking
        number_only = false; # Peek only when the command is only a number instead of when it starts with a number
        centered_peeking = true; # Peeked line will be centered relative to window
      };
    }
    {
      pkg = treesj;
      dependencies = [nvim-treesitter];
      opts.dot_repeat = false;
    }
    {
      pkg = ts-node-action;
      opts = {};
    }
    {
      pkg = ssr-nvim;
      config = true;
    }
    nvim-bqf
  ];
}
