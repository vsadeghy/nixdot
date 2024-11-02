{lib, ...}: let
  inherit (import ./maps.nix {inherit lib;}) nmap vmap imap;
in {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = let
      normal = nmap {
        "<Space>" = ["<Nop>"];
        "gx" = ["<Nop>"];

        "<leader>s" = ["<cmd>write<cr>" "Save File"];
        "<leader>x" = ["<cmd>quit<cr>" "Quit File"];

        # save file without auto-formatting
        "<leader>S" = ["<cmd>noautocmd w<cr>"];

        # delete single character without copying into register
        "x" = [''"_x''];

        # Vertical scroll and center
        "<C-d>" = ["<C-d>zz"];
        "<C-u>" = ["<C-u>zz"];
        "<C-o>" = ["<C-o>zz"];
        "<C-i>" = ["<C-i>zz"];

        # Find and center
        "n" = ["nzzzv"];
        "N" = ["Nzzzv"];

        # fix Y behaviour
        "Y" = ["y$"];

        # Press 'H', 'L' to jump to start/end of a line (first/last character)
        "L" = ["$"];
        "H" = ["^"];

        # Resize with arrows
        "<Up>" = ["<cmd>resize -2<cr>"];
        "<Down>" = ["<cmd>resize +2<cr>"];
        "<Left>" = ["<cmd>vertical resize -2<cr>"];
        "<Right>" = ["<cmd>vertical resize +2<cr>"];

        # Buffers
        "<Tab>" = ["<cmd>bnext<cr>"];
        "<S-Tab>" = ["<cmd>bprevious<cr>"];
        "<leader>q" = ["<cmd>bdelete!<cr>" "Close Buffer"];
        "<leader>b" = ["<cmd>enew<cr>" "New Buffer"];

        # Window management
        "<leader>w" = ["<Nop>" "Window"];
        "<leader>wv" = ["<C-w>v" "Split Vertically"];
        "<leader>wh" = ["<C-w>s" "Split Horizontally"];
        "<leader>w=" = ["<C-w>=" "Equal Splits"];
        "<leader>wq" = ["<cmd>close<cr>" "Close window"];

        # Navigate between splits
        # "<C-k>" = ["<cmd>wincmd k<cr>"];
        # "<C-j>" = ["<cmd>wincmd j<cr>"];
        # "<C-h>" = ["<cmd>wincmd h<cr>"];
        # "<C-l>" = ["<cmd>wincmd l<cr>"];

        # move current line up/down
        "<M-k>" = ["<cmd>move-2<cr>"];
        "<M-j>" = ["<cmd>move+<cr>"];

        # Tabs
        "<leader>t" = ["<Nop>" "toggle"];
        "<leader>tw" = ["<cmd>set wrap!<cr>" "Toggle Line Wrap"];
        "<leader>th" = ["<cmd>set hlsearch!<cr>" "Toggle Highlight Search"];

        # Diagnostic keymaps
        "[d" = [
          {__raw = "vim.diagnostic.goto_prev";}
          "Go to previous diagnostic message"
        ];
        "]d" = [
          {__raw = "vim.diagnostic.goto_next";}
          "Go to next diagnostic message"
        ];
        "<leader>l" = ["<Nop>" "LSP"];
        "<leader>ld" = [
          {__raw = "vim.diagnostic.open_float";}
          "Open floating diagnostic message"
        ];
        "<leader>lq" = [
          {__raw = "vim.diagnostic.setloclist";}
          "Open diagnostics list"
        ];

        # Easy comment
        # "<leader>/" = [ "gcc" ];

        # Use Menu key to cycle with the recent file
        "" = ["<cmd>b#<cr>"];
      };

      visual = vmap {
        # Disable the spacebar key's default behavior in Normal and Visual modes
        "<Space>" = ["<Nop>"];

        # Stay in indent mode
        "<" = ["<gv"];
        ">" = [">gv"];
        "<Tab>" = ["<gv"];
        "<S-Tab>" = [">gv"];

        "p" = [''"_dP''];
        # Keep last yanked when pasting

        # Move selected line / block of text in visual mode
        "K" = ["<cmd>m '<-2<cr>gv=gv"];
        "J" = ["<cmd>m '>+1<cr>gv=gv"];

        # Easy comment
        # "<leader>/" = [ "gc" ];
      };
      insert = imap {
        # Easy escape
        "jk" = ["<esc>"];
        "kj" = ["<esc>"];

        # Use Menu key to cycle with the recent file
        "" = ["<cmd>b#<cr>"];
      };
    in (normal ++ visual ++ insert);
  };
}
