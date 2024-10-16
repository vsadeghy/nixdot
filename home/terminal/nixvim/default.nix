{ inputs, ... }: {
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins
  ];
  home.shellAliases.v = "nvim";
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    # performance = {
    #   combinePlugins = {
    #     enable = true;
    #     standalonePlugins = [
    #       # "hmts.nvim"
    #       # "neorg"
    #       "nvim-treesitter"
    #     ];
    #   };
    #   byteCompileLua.enable = true;
    # };
    vimAlias = true;
    luaLoader.enable = true;
  };
}
