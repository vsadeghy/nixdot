{ inputs, ... }: {
  imports = [
    ./options.nix
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
    vimAlias = true;
    luaLoader.enable = true;
  };
}
