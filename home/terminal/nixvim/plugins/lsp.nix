{
  lib,
  pkgs,
  config,
  ...
}: let
  lua = config.lib.nixvim.toLuaObject;
  inherit (import ../maps.nix {inherit lib;}) nmap;
  servers = {
    ts_ls = {};
    html = {filetypes = ["html" "twig" "hbs"];};
    cssls = {};
    tailwindcss = {};
    jsonls = {};
    nil_ls = {};
    lua_ls = {
      cmd = ["${pkgs.lua-language-server}/bin/lua-language-server"];
      settings.Lua = {
        completion.callSnippet = "Replace";
        runtime.version = "LuaJIT";
        workspace = {
          checkThirdParty = false;
          library = [
            "\${3rd}/lua/library"
            "unpack(vim.api.vnim_get_runtime_file('', true))"
          ];
        };
        diagonstics = {
          global = ["vim"];
          disable = ["missing-fields"];
        };
        format.enable = false;
        telemetry.enable = false;
      };
    };
  };
  ensure_installed = ["stylua"] ++ lib.attrsets.mapAttrsToList (name: _: name) servers;
in {
  home.packages = with pkgs; [typescript cargo];
  programs.nixvim = {
    keymapsOnEvents.LspAttach = nmap {
      "gd" = [":Telescope lsp_definitions<cr>" {desc = "Goto Definition";}];
      "gr" = [":Telescope lsp_references<cr>" {desc = "Goto References";}];
      "gi" = [":Telescope lsp_implementations<cr>" {desc = "Goto Implementation";}];
      "gT" = [":Telescope lsp_type_definitions<cr>" {desc = "Goto Type definitions";}];
      "gD" = [":lua vim.lsp.buf.declaration()<cr>" {desc = "Goto Declaration";}];
      "gs" = [":Telescope lsp_document_symbols<cr>" {desc = "Goto Symbols";}];
      "gS" = [":Telescope lsp_dynamic_workspace_symbols<cr>" {desc = "Goto Workspace Symbols";}];
      "<leader>la" = [":lua vim.lsp.buf.code_action()<cr>" {desc = "Code Action";}];
      "<leader>lr" = [":lua vim.lsp.buf.rename()<cr>" {desc = "Rename";}];
    };
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        pkg = nvim-lspconfig;
        dependencies = [
          telescope-nvim
          {
            pkg = mason-nvim;
            config = true;
          }
          mason-lspconfig-nvim
          {
            pkg = mason-tool-installer-nvim;
            opts = {inherit ensure_installed;};
          }
          cmp-nvim-lsp
          {
            pkg = fidget-nvim;
            opts = {};
          }
        ];
        config.__raw =
          /*
          lua
          */
          ''
            function()
              vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(e)
                  local client = vim.lsp.get_client_by_id(e.data.client_id)
                  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                      buffer = e.buf,
                      group = highlight_augroup,
                      callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                      buffer = e.buf,
                      group = highlight_augroup,
                      callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                      callback = function(e2)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e2.buf }
                      end,
                    })
                  end

                  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    vim.keymap.set('n', '<leader>th', function()
                      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = e.buf })
                    end, {buffer = e.buf, desc =  '[T]oggle Inlay [H]ints' })
                  end
                end,
              })

              local capabilities = vim.lsp.protocol.make_client_capabilities()
              capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
              local servers = ${lua servers}
              require('mason-lspconfig').setup {
                handlers = {
                  function (server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    require('lspconfig')[server_name].setup(server)
                  end
                }
              }
            end
          '';
      }
      {
        pkg = typescript-tools-nvim;
        dependencies = [plenary-nvim nvim-lspconfig];
        opts = {};
      }
    ];
  };
}
