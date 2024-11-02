{
  lib,
  pkgs,
  ...
}: let
  inherit (import ../maps.nix {inherit lib;}) nmap vmap;
in {
  programs.nixvim = {
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        pkg = gitsigns-nvim;
        opts = let
          signs = {
            add.text = "+";
            change.text = "~";
            topdelete.text = "‾";
            delete.text = "_";
            changedelete.text = "~";
          };
        in {
          inherit signs;
          signs_staged = signs;
        };
      }
    ];
    keymaps =
      nmap {
        "<leader>g" = ["<nop>" "Git"];
        "<leader>go" = ["<cmd>Neogit kind=floating<cr>" "Open Neogit"];
        "<leader>gj" = ["<cmd>Gitsigns next_hunk<cr>" "Next Hunk"];
        "<leader>gk" = ["<cmd>Gitsigns prev_hunk<cr>" "Prev Hunk"];
        "<leader>gs" = ["<cmd>Gitsigns stage_hunk<cr>" "Stage Hunk"];
        "<leader>gr" = ["<cmd>Gitsigns reset_hunk<cr>" "Reset Hunk"];
        "<leader>gS" = ["<cmd>Gitsigns stage_buffer<cr>" "Stage Buffer"];
        "<leader>gu" = ["<cmd>Gitsigns undo_stage_hunk<cr>" "Undo Stage Hunk"];
        "<leader>gp" = ["<cmd>Gitsigns preview_hunk<cr>" "Preview Hunk"];
        "<leader>gb" = ["<cmd>Gitsigns blame_line full=true<cr>" "Blame Line"];
        "<leader>tb" = ["<cmd>Gitsigns toggle_current_line_blame<cr>" "Line Blame"];
        "<leader>gh" = ["<cmd>Gitsigns git_branches<cr>" "Branches"];
        "<leader>gc" = ["<cmd>Telescope git_commits<cr>" "Commits"];
        "<leader>gC" = ["<cmd>Telescope git_bcommits<cr>" "Branch Commits"];
        "<leader>g?" = ["<cmd>Telescope git_status<cr>" "Status"];
        "<leader>gd" = ["<cmd>Gitsigns diffthis<cr>" "diff"];
        "<leader>gD" = ["<cmd>Gitsigns diffthis '~'<cr>" "diff w/ Head"];
        "<leader>td" = ["<cmd>Gitsigns toggle_deleted<cr>" "Toggle Deleted"];
      }
      ++ vmap {
        "<leader>g" = ["<nop>" "Git"];
        "<leader>gs" = ["<cmd>Gitsigns stage_hunk<cr>" "Stage Hunk"];
        "<leader>gr" = ["<cmd>Gitsigns reset_hunk<cr>" "Reset Hunk"];
        "<leader>gu" = ["<cmd>Gitsigns undo_stage_hunk<cr>" "Undo Stage Hunk"];
      };
  };
}
