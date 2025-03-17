{
  lib,
  pkgs,
  ...
}: let
  inherit (import ../maps.nix {inherit lib;}) nmap;
in {
  programs.nixvim = {
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        pkg = conform-nvim;
        dependencies = [repeat];
        event = ["ButWritePre"];
        cmd = ["ConformInfo"];
        config.__raw = ''
          function()
            local prettier = {"prettierd", "prettier", stop_after_first = true}

            local function find_config(bufnr, config_files)
              return vim.fs.find(config_files, {
                upward = true,
                stop = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
                path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
              })[1]
            end
            local function biome_or_prettier(bufnr)
              local has_biome = find_config(bufnr, {"biome.json", "biome.jsonc"})
              if has_biome then
                return {"biome"}
              end
              local has_prettier = find_config(bufnr, {
                -- https://prettier.io/docs/en/configuration.html
                ".prettierrc",
                ".prettierrc.json",
                ".prettierrc.yml",
                ".prettierrc.yaml",
                ".prettierrc.json5",
                ".prettierrc.js",
                ".prettierrc.cjs",
                ".prettierrc.mjs",
                ".prettierrc.toml",
                ".prettierrc.ts",
                ".prettierrc.cts",
                ".prettierrc.mts",
                "prettier.config.js",
                "prettier.config.cjs",
                "prettier.config.ts",
                "prettier.config.mjs",
              })
              if has_prettier then
                return prettier
              end

              -- default
              return { "biome", "prettierd", "prettier", stop_after_first = true }
            end

            require("conform").setup({
              formatters_by_ft = {
                javascript = biome_or_prettier,
                javascriptreact = biome_or_prettier,
                typescript = biome_or_prettier,
                typescriptreact = biome_or_prettier,
                html = prettier,
                css = biome_or_prettier,
                less = prettier,
                scss = prettier,
                json = biome_or_prettier,
                jsonc = biome_or_prettier,
                yaml = prettier,
                markdown = prettier,
                svelte = prettier,
                sh = {"shfmt"}
              },
              formatters = {
                biome = {
                  args = {"--config-path", ${./biome.json}}
                },
                shfmt = {
                  args = {"-i", "4"},
                },
              },
              default_format_opts = {
                lsp_format = "fallback",
              },
              format_on_save = {
                lsp_format = "fallback",
                timeout_ms = 500,
              },
            })
          end
        '';
        # opts = {
        #   formatters_by_ft = {
        #     html = prettier;
        #     css = prettier;
        #     javascript = prettier;
        #     javascriptreact = prettier;
        #     typescript = prettier;
        #     typescriptreact = prettier;
        #     json = prettier;
        #     jsonc = prettier;
        #     yaml = prettier;
        #     markdown = prettier;
        #     sh = ["shfmt"];
        #     python = ["black"];
        #   };
        #   default_format_opts = {
        #     lsp_format = "fallback";
        #   };
        #   format_on_save = {
        #     lsp_format = "fallback";
        #     timeout_ms = 500;
        #   }
        # };
      }
    ];
    keymaps = nmap {
      s = ["<cmd>HopCamelCaseMW<cr>"];
      S = ["<cmd>HopChar2MW<cr>"];
      f = ["<cmd>HopChar1CurrentLineAC<cr>"];
      F = ["<cmd>HopChar1CurrentLineBC<cr>"];
      "<leader>j" = ["<nop>" "Jump"];
      "<leader>jw" = ["<cmd>HopWordMW<cr>" "Jump Word"];
      "<leader>jl" = ["<cmd>HopLineStartMW<cr>" "Jump Line ^"];
      "<leader>jL" = ["<cmd>HopLineMW<cr>" "Jump Line 0"];
      "<leader>j/" = ["<cmd>HopAnywhereMW<cr>" "Find Char"];
      "<leader>jf" = ["<cmd>HopChar1CurrentLineAC<cr>" "Find Forwards"];
      "<leader>jF" = ["<cmd>HopChar1CurrentLineBC<cr>" "Find Backwards"];
      "<leader>jy" = ["<cmd>HopYankChar1MW<cr>" "Yank"];
      "<leader>jp" = ["<cmd>HopPasteChar1MW<cr>" "Paste"];
    };
  };
}
