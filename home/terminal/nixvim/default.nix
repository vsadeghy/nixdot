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
    colorschemes = {
      catppuccin = {
        enable = true;
        settings = {
          flavour = "macchiato";
        };
      };
    };
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