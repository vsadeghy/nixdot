{lib, ...}: {
  programs.nixvim = {
    opts = {
      number = true; # Set numbered lines (default: false)
      signcolumn = "yes"; # Keep signcolumn on by default (default: "auto")
      relativenumber = true; # Set relative numbered lines (default: false)
      wrap = false; # Display lines as one long line (default: true)
      linebreak = true; # Companion to wrap, don"t split words (default: false)
      mouse = "a"; # Enable mouse mode (default: "")
      autoindent = true; # Copy indent from current line when starting new one (default: true)
      ignorecase = true; # Case-insensitive searching UNLESS \C or capital in search (default: false)
      smartcase = true; # Smart case (default: false)
      shiftwidth = 2; # The number of spaces inserted for each indentation (default: 8)
      tabstop = 2; # Insert n spaces for a tab (default: 8)
      softtabstop = 2; # Number of spaces that a tab counts for while performing editing operations (default: 0)
      expandtab = true; # Convert tabs to spaces (default: false)
      scrolloff = 4; # Minimal number of screen lines to keep above and below the cursor (default: 0)
      sidescrolloff = 8; # Minimal number of screen columns either side of cursor if wrap is `false` (default: 0)
      cursorline = true; # Highlight the current line (default: false)
      splitbelow = true; # Force all horizontal splits to go below current window (default: false)
      splitright = true; # Force all vertical splits to go to the right of current window (default: false)
      hlsearch = false; # Set highlight on search (default: true)
      showmode = false; # We don"t need to see things like -- INSERT -- anymore (default: true)
      whichwrap = "bs<>[]hl"; # Which "horizontal" keys are allowed to travel to prev/next line (default: "b,s")
      numberwidth = 4; # Set number column width to 2 {default 4} (default: 4)
      swapfile = false; # Creates a swapfile (default: true)
      smartindent = true; # Make indenting smarter again (default: false)
      showtabline = 2; # Always show tabs (default: 1)
      backspace = "indent,eol,start"; # Allow backspace on (default: "indent,eol,start")
      pumheight = 10; # Pop up menu height (default: 0)
      conceallevel = 0; # So that `` is visible in markdown files (default: 1)
      fileencoding = "utf-8"; # The encoding written to a file (default: "utf-8")
      cmdheight = 1; # More space in the Neovim command line for displaying messages (default: 1)
      breakindent = true; # Enable break indent (default: false)
      updatetime = 250; # Decrease update time (default: 4000)
      timeoutlen = 300; # Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
      backup = false; # Creates a backup file (default: false)
      writebackup = false; # If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited (default: true)
      undofile = true; # Save undo history (default: false)
      completeopt = "menuone,noselect"; # Set completeopt to have a better completion experience (default: "menu,preview")
      termguicolors = true; # Set termguicolors to enable highlight groups (default: false)
      # shortmess = "ltToOCFc"; # Don"t give |ins-completion-menu| messages (default: does not include "c")
      # iskeyword = "@,38-57,_,192-255,-"; # Hyphenated words recognized by searches (default: does not include "-")
      # formatoptions = "ql"; # Don"t insert the current comment leader automatically for auto-wrapping comments using "(t)extwidth", hitting <Ente(r)> in insert mode, or hitting "o" or "O" in normal mode. (default: "croql")
      # vim.opt.runtimepath:remove "/usr/share/vim/vimfiles"; # separate vim plugins from neovim in case vim still in use (default: includes this path if vim is installed)
      title = true;
      listchars = "eol:¬,tab:>-,trail:~,extends:>,precedes:<";
      list = true;
      lazyredraw = false;
      hidden = true;
    };

    globals = let
      d = [
        "netrw"
        "netrwPlugin"
        "netrwSettings"
        "netrwFileHandlers"
        "gzip"
        "zip"
        "zipPlugin"
        "tar"
        "tarPluin"
        "matchit"
        "getscript"
        "getscriptPlugin"
        "vimball"
        "vimballPlugin"
        "2html_plugin"
        "logipat"
        "rrhelper"
        "spellfile_plugin"
      ];
      disableBuiltins = builtins.listToAttrs (map (p: lib.attrsets.nameValuePair ("loaded_" + p) 1) d);
    in
      {
        mapleader = " ";
        maplocalleader = " ";
        reSize = 5; # <C-w> resize amount,
        shell = "/bin/zsh";
      }
      // disableBuiltins;

    clipboard = {
      register = "unnamedplus";
      providers.xsel.enable = true;
    };
  };
}
