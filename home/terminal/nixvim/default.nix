{ inputs, ... }: {
  imports = [
    ./options.nix
    ./keymaps.nix
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
    plugins.which-key.enable = true;
    vimAlias = true;
    luaLoader.enable = true;
  };
}
