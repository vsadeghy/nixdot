{pkgs, ...}: let
  none-ls-extras = pkgs.vimUtils.buildVimPlugin {
    name = "none-ls-extras";
    src = pkgs.fetchFromGitHub {
      "owner" = "nvimtools";
      "repo" = "none-ls-extras.nvim";
      "rev" = "f2bb002c8aa644d1f253772ff5d4e75e45ff7f4f";
      "hash" = "sha256-1Mq9IGu3e+ganwLaY+8lE7puvTiQl3WzuvmCqMYXOMc=";
    };
  };
  mason-null-ls = pkgs.vimUtils.buildVimPlugin {
    name = "mason-null-ls";
    src = pkgs.fetchFromGitHub {
      "owner" = "jayp0521";
      "repo" = "mason-null-ls.nvim";
      "rev" = "de19726de7260c68d94691afb057fa73d3cc53e7";
      "hash" = "sha256-2q8XS0mSxxpZumKVAJ8iYZBElS/v6rzH1x8WcPGmuss=";
    };
  };
in {
  home = {
    packages = with pkgs; [biome alejandra];
  };
  programs.nixvim = {
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        pkg = none-ls-nvim;
        dependencies = [
          none-ls-extras
          mason-null-ls
        ];
        config.__raw = ''
          function()
            local null_ls = require 'null-ls'
            local formatting = null_ls.builtins.formatting
            local diagnostics = null_ls.builtins.diagnostics

            require('mason-null-ls').setup {
              ensure_installed = {
                'prettier',
                'stylua',
                'eslint_d',
                'shfmt',
              },
              automatic_installation = true,
            }

            local sources = {
              diagnostics.dotenv_linter,
              formatting.stylua,
              formatting.biome,
              formatting.prettier.with {filetypes = {"html",  "yaml", "markdown", "svelte"}},
              formatting.alejandra,
              formatting.shfmt.with { args = {'-i', '4'} },
            }

            local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
            null_ls.setup {
              sources = sources,
              -- format on save
              on_attach = function(client, bufnr)
                if client.supports_method 'textDocument/formatting' then
                  vim.keymap.set('n', '<leader>lf',
                    function() vim.lsp.buf.format { async = false } end,
                    {buffer = bufnr, desc =  'Format' }
                  )

                  vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
                  vim.api.nvim_create_autocmd('BufWritePre', {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                      vim.lsp.buf.format { async = false }
                    end,
                  })
                end
              end,
            }
          end
        '';
      }
    ];
  };
}
