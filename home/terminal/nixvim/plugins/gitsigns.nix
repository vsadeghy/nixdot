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
        "<leader>g" = ["<nop>" {desc = "Git";}];
        "<leader>gg" = [":Neogit kind=floating<cr>" {desc = "Next Hunk";}];
        "<leader>gj" = [":Gitsigns next_hunk<cr>" {desc = "Next Hunk";}];
        "<leader>gk" = [":Gitsigns prev_hunk<cr>" {desc = "Prev Hunk";}];
        "<leader>gs" = [":Gitsigns stage_hunk<cr>" {desc = "Stage Hunk";}];
        "<leader>gr" = [":Gitsigns reset_hunk<cr>" {desc = "Reset Hunk";}];
        "<leader>gS" = [":Gitsigns stage_buffer<cr>" {desc = "Stage Buffer";}];
        "<leader>gu" = [":Gitsigns undo_stage_hunk<cr>" {desc = "Undo Stage Hunk";}];
        "<leader>gp" = [":Gitsigns preview_hunk<cr>" {desc = "Preview Hunk";}];
        "<leader>gb" = [":Gitsigns blame_line full=true<cr>" {desc = "Blame Line";}];
        "<leader>tb" = [":Gitsigns toggle_current_line_blame<cr>" {desc = "Line Blame";}];
        "<leader>gh" = [":Gitsigns git_branches<cr>" {desc = "Branches";}];
        "<leader>gc" = [":Telescope git_commits<cr>" {desc = "Commits";}];
        "<leader>gC" = [":Telescope git_bcommits<cr>" {desc = "Branch Commits";}];
        "<leader>g?" = [":Telescope git_status<cr>" {desc = "Status";}];
        "<leader>gd" = [":Gitsigns diffthis<cr>" {desc = "diff";}];
        "<leader>gD" = [":Gitsigns diffthis '~'<cr>" {desc = "diff w/ Head";}];
        "<leader>td" = [":Gitsigns toggle_deleted<cr>" {desc = "Toggle Deleted";}];
      }
      ++ vmap {
        "<leader>g" = ["<nop>" {desc = "Git";}];
        "<leader>gs" = [":Gitsigns stage_hunk<cr>" {desc = "Stage Hunk";}];
        "<leader>gr" = [":Gitsigns reset_hunk<cr>" {desc = "Reset Hunk";}];
        "<leader>gu" = [":Gitsigns undo_stage_hunk<cr>" {desc = "Undo Stage Hunk";}];
      };
  };
}
