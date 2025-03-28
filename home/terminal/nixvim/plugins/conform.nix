{
  lib,
  pkgs,
  ...
}: let
  inherit (import ../maps.nix {inherit lib;}) nmap;
in {
  home = {
    packages = with pkgs; [biome alejandra];
  };
  programs.nixvim = {
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        pkg = conform-nvim;
        dependencies = [repeat];
        event = ["BufWritePre"];
        cmd = ["ConformInfo"];
        config.__raw =
          /*
          lua
          */
          ''
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
                  return {"biome-check"}
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
                return { "biome-check", "prettierd", "prettier", stop_after_first = true }
              end

              require("conform").setup({
                formatters_by_ft = {
                  javascript = prettier,
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
                    command = "${pkgs.biome}/bin/biome",
                    args = {"--config-path", "${./biome.json}"}
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
      }
    ];
    keymaps = nmap {
      "<leader>lf" = [{__raw = ''function() require("conform").format({ async = true }) end'';} "Format"];
    };
  };
}
