{ config, options, lib, ... }: let
  inherit (import ./maps.nix { inherit lib; }) nmap vmap imap;
in {

  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = let
      normal = nmap {
        "<Space>" = [ "<Nop>" ];
        "gx" = [ "<Nop>" ];

        "<leader>s" = [ ":write<cr>" { desc = "Save File";} ];
        "<leader>x" = [ ":quit<cr>" { desc = "Quit File";} ];

        # save file without auto-formatting
        "<leader>S" = [ ":noautocmd w<cr>" ];


        # delete single character without copying into register
        "x" = [ ''"_x'' ];

        # Vertical scroll and center
        "<C-d>" = [ "<C-d>zz" ];
        "<C-u>" = [ "<C-u>zz" ];
        "<C-o>" = [ "<C-o>zz" ];
        "<C-i>" = [ "<C-i>zz" ];

        # Find and center
        "n" = [ "nzzzv" ];
        "N" = [ "Nzzzv" ];

        # fix Y behaviour
        "Y" = ["y$"];

        # Press 'H', 'L' to jump to start/end of a line (first/last character)
        "L" = ["$"];
        "H" = ["^"];

        # Resize with arrows
        "<Up>" = [ ":resize -2<cr>" ];
        "<Down>" = [ ":resize +2<cr>" ];
        "<Left>" = [ ":vertical resize -2<cr>" ];
        "<Right>" = [ ":vertical resize +2<cr>" ];

        # Buffers
        "<Tab>" = [ ":bnext<cr>" ];
        "<S-Tab>" = [ ":bprevious<cr>" ];
        "<leader>q" = [ ":bdelete!<cr>" { desc = "Close Buffer"; }];
        "<leader>b" = [ ":enew<cr>" { desc = "New Buffer"; }];

        # Window management
        "<leader>w" = [ "<Nop>" { desc = "Window"; }];
        "<leader>wv" = [ "<C-w>v" { desc = "Split Vertically"; }];
        "<leader>wh" = [ "<C-w>s" { desc = "Split Horizontally"; }];
        "<leader>w=" = [ "<C-w>=" { desc = "Equal Splits"; }];
        "<leader>wq" = [ ":close<cr>" { desc = "Close window"; }];

        # Navigate between splits
        "<C-k>" = [ ":wincmd k<cr>" ];
        "<C-j>" = [ ":wincmd j<cr>" ];
        "<C-h>" = [ ":wincmd h<cr>" ];
        "<C-l>" = [ ":wincmd l<cr>" ];

        # move current line up/down
        "<M-k>" = [ ":move-2<cr>"];
        "<M-j>" = [ ":move+<cr>"];

        # Tabs
        "<leader>t" =  [ "<Nop>" { noremap = false; desc = "Tab"; }];
        "<leader>to" = [ ":tabedit<cr>" { desc = "Open New tab"; }];
        "<leader>tq" = [ ":tabclose<cr>" { desc = "Close tab"; }];
        "<leader>tn" = [ ":tabnext<cr>" { desc = "Next tab"; }];
        "<leader>tp" = [ ":tabprevious<cr>" { desc = "Previous tab"; }];

        # Toggle line wrapping <cr>
        "<leader>T" =  [ "<Nop>" { noremap = false; desc = "Toggle"; }];
        "<leader>Tw" = [ ":set wrap!<cr>" {desc = "Toggle Line Wrap"; }];
        "<leader>Th" = [ ":set hlsearch!<cr>" {desc = "Toggle Highlight Search"; }];

        # Diagnostic keymaps
        "[d" = [
          { __raw = "vim.diagnostic.goto_prev"; }
          { desc = "Go to previous diagnostic message"; }
        ];
        "]d" = [
          { __raw = "vim.diagnostic.goto_next"; }
          { desc = "Go to next diagnostic message"; }
        ];
        "<leader>l" =  [ "<Nop>" { noremap = false; desc = "LSP"; }];
        "<leader>ld" = [
          { __raw = "vim.diagnostic.open_float"; }
          { desc = "Open floating diagnostic message"; }
        ];
        "<leader>lq" = [
          { __raw = "vim.diagnostic.setloclist"; }
          { desc = "Open diagnostics list"; }
        ];

        # Easy comment
        # "<leader>/" = [ "gcc" ];

        # Use Menu key to cycle with the recent file
        "" = [":b#<cr>" ];
      };

      visual = vmap {
        # Disable the spacebar key's default behavior in Normal and Visual modes
        "<Space>" = [ "<Nop>" ];

        # Stay in indent mode
        "<" = [ "<gv" ];
        ">" = [ ">gv" ];
        "<Tab>" = [ "<gv" ];
        "<S-Tab>" = [ ">gv" ];

        "p" = [ ''"_dP'' ];
        # Keep last yanked when pasting

        # Move selected line / block of text in visual mode
        "K" = [ ":m '<-2<cr>gv=gv" ];
        "J" = [ ":m '>+1<cr>gv=gv" ];

        # Easy comment
        # "<leader>/" = [ "gc" ];
      };
      insert = imap {
        # Easy escape
        "jk" = ["<esc>"];
        "kj" = ["<esc>"];

        # Use Menu key to cycle with the recent file
        "" = [":b#<cr>"];
      };
    in (normal ++ visual ++ insert);
  };
}
