{pkgs, ...}: {
  programs.nixvim = {
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        pkg = harpoon2;
        dependencies = [plenary-nvim];
        config.__raw = ''
          function()
            local harpoon = require("harpoon");
            harpoon:setup()
            local map = function (key, cmd, desc)
              vim.keymap.set("n", key, cmd, {desc = desc, noremap = true, silent = true})
            end

            map("<leader>a", function() harpoon:list():add() end, "Harpoon Add")
            map("<leader>o", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Harpoon Open")

            map("<A-j>", function() harpoon:list():select(1) end, "Select 1")
            map("<A-k>", function() harpoon:list():select(2) end, "Select 2")
            map("<A-l>", function() harpoon:list():select(3) end, "Select 3")
            map("<A-;>", function() harpoon:list():select(4) end, "Select 4")

            -- map("<C-S-j>", function() harpoon:list():next() end, "Next")
            -- map("<C-S-k>", function() harpoon:list():prev() end, "Prev")
          end
        '';
      }
    ];
  };
}
