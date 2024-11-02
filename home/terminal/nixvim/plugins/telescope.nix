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
        pkg = telescope-nvim;
        # lazy = false;
        event = "VimEnter";
        dependencies = [
          plenary-nvim
          popup-nvim
          telescope-fzf-native-nvim
          telescope-ui-select-nvim
          telescope-media-files-nvim
          telescope-project-nvim
          telescope-undo-nvim
          {
            pkg = nvim-web-devicons;
            enabled.__raw = "vim.g.have_nerd_font";
          }
        ];
        init.__raw = ''
          function()
            require("telescope").setup {
              defaults = {
                sorting_strtegy = "ascending",
                layout_strategy = "flex",
                file_ignore_patterns = {
                  "node_modules",
                  ".git",
                  "dist",
                  "package-lock.json",
                  "yarn.lock",
                },
                layout_config = {
                  prompt_position = "top",
                  horizontal = { mirror = false, preview_cutoff = 100, preview_width = 0.60 },
                  vertical = { mirror = true, preview_cutoff = 0.4 },
                },
              },
              extensions = {
                ["ui-select"] = {
                  require("telescope.themes").get_dropdown(),
                },
                media_files = {find_cmd = "rg"},
              },
            }

            require("telescope").load_extension("fzf")
            require("telescope").load_extension("ui-select")
            require("telescope").load_extension("media_files")
            require("telescope").load_extension("project")
            require("telescope").load_extension("undo")
          end
        '';
      }
    ];

    keymaps = nmap {
      "<leader>f" = ["<nop>" "Find"];
      "<leader>ff" = ["<cmd>Telescope find_files<cr>" "Find Files"];
      "<leader>fc" = ["<cmd>Telescope commands<cr>" "Find Files"];
      "<leader>fC" = ["<cmd>Telescope command_history<cr>" "Find Files"];
      "<leader>ft" = ["<cmd>Telescope live_grep<cr>" "Find Text"];
      "<leader>fd" = ["<cmd>Telescope diagnostics<cr>" "Find Diagnostics"];
      "<leader>fr" = ["<cmd>Telescope oldfiles<cr>" "Find Recent Files"];
      "<leader>fp" = ["<cmd>Telescope project<cr>" "Find Recent Files"];
      "<leader>fw" = ["<cmd>Telescope grep_string<cr>" "Find current Word"];
      "<leader>fk" = ["<cmd>Telescope keymaps<cr>" "Find Keymaps"];
      "<leader>fh" = ["<cmd>Telescope help_tags<cr>" "Find Help"];
      "<leader>/" = [
        {
          __raw = ''
            function()
              require("telescope.builtin").live_grep ({
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files",
              })
            end
          '';
        }
        "Find Text"
      ];
      # "/" = [
      #   {
      #     __raw = ''
      #       function()
      #         require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
      #           winblend = 10,
      #           previewer =  false,
      #         })
      #       end
      #     '';
      #   } "Find Text"
      # ];
    };
  };
}
