{pkgs, ...}: {
  programs.nixvim.plugins = {
    lazy = {
      plugins = with pkgs.vimPlugins; [
        {
          pkg = nvim-cmp;
          dependencies = [
            {
              pkg = luasnip;
              dependencies = [
                {
                  pkg = friendly-snippets;
                  config.__raw = "function() require('luasnip.loaders.from_vscode').lazy_load() end";
                }
              ];
            }
            cmp_luasnip
            cmp-nvim-lsp
            cmp-buffer
            cmp-path
            {
              # pkg = codeium-nvim;
              pkg = supermaven-nvim;
              opts.keymaps = {
                accept_suggestion = "<right>";
                accept_word = "<C-right>";
                clear_suggestion = "<C-left>";
              };
            }
          ];
          config.__raw = ''
            function()
              -- See `:help cmp`
              local cmp = require 'cmp'
              local luasnip = require 'luasnip'
              luasnip.config.setup {}

              local kind_icons = {
                Class          = "󰌗 ",
                -- Codeium        = " ",
                Color          = "󰏘 ",
                Constant       = "󰏿 ",
                Constructor    = " ",
                Enum           = "󰕘 ",
                EnumMember     = " ",
                Event          = " ",
                Field          = " ",
                File           = "󰈙 ",
                Folder         = "󰉋 ",
                Function       = "󰊕 ",
                Interface      = "󰕘 ",
                Keyword        = "󰌋 ",
                Method         = "m ",
                Module         = " ",
                Operator       = "󰆕 ",
                Property       = " ",
                Reference      = " ",
                Snippet        = " ",
                Struct         = "󰌗 ",
                Supermaven     = " ",
                Text           = "󰉿 ",
                TypeParameter  = "󰊄 ",
                Unit           = " ",
                Value          = "󰎠 ",
                Variable       = "󰆧 ",
              }
              cmp.setup {
                snippet = {
                  expand = function(args)
                    luasnip.lsp_expand(args.body)
                  end,
                },
                completion = { completeopt = 'menu,menuone,noinsert' },

                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                mapping = cmp.mapping.preset.insert {
                  -- Select the [n]ext item
                  ['<C-n>'] = cmp.mapping.select_next_item(),
                  -- Select the [p]revious item
                  ['<C-p>'] = cmp.mapping.select_prev_item(),

                  -- Scroll the documentation window [b]ack / [f]orward
                  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),

                  -- Accept ([y]es) the completion.
                  --  This will auto-import if your LSP supports it.
                  --  This will expand snippets if the LSP sent a snippet.
                  ['<C-y>'] = cmp.mapping.confirm { select = true },

                  -- If you prefer more traditional completion keymaps,
                  -- you can uncomment the following lines
                  ['<CR>'] = cmp.mapping.confirm { select = true },
                  -- ['<Tab>'] = cmp.mapping.select_next_item(),
                  -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),

                  -- Manually trigger a completion from nvim-cmp.
                  --  Generally you don't need this, because nvim-cmp will display
                  --  completions whenever it has completion options available.
                  ['<C-Space>'] = cmp.mapping.complete {},

                  -- Think of <c-l> as moving to the right of your snippet expansion.
                  --  So if you have a snippet that's like:
                  --  function $name($args)
                  --    $body
                  --  end
                  --
                  -- <c-l> will move you to the right of each of the expansion locations.
                  -- <c-h> is similar, except moving you backwards.
                  ['<C-l>'] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                      luasnip.expand_or_jump()
                    end
                  end, { 'i', 's' }),
                  ['<C-h>'] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                      luasnip.jump(-1)
                    end
                  end, { 'i', 's' }),

                  -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                  --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                  -- Select next/previous item with Tab / Shift + Tab
                  ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                      cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                      luasnip.expand_or_jump()
                    else
                      fallback()
                    end
                  end, { 'i', 's' }),
                  ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                      cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                      luasnip.jump(-1)
                    else
                      fallback()
                    end
                  end, { 'i', 's' }),
                },
                sources = {
                  {
                    name = 'lazydev',
                    -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
                    group_index = 0,
                  },
                  { name = 'nvim_lsp' },
                  { name = 'luasnip' },
                  { name = 'buffer' },
                  { name = 'path' },
                  -- { name = 'supermaven' },
                },
                formatting = {
                  fields = { 'kind', 'abbr', 'menu' },
                  format = function(entry, vim_item)
                    vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
                    vim_item.menu = ({
                      nvim_lsp = '[LSP]',
                      supermaven = '[AI]',
                      luasnip = '[Snippet]',
                      buffer = '[Buffer]',
                      path = '[Path]',
                    })[entry.source.name]
                    return vim_item
                  end,
                },
              }
            end
          '';
        }
      ];
    };
  };
}
