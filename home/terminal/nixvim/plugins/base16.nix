{config, pkgs, ...}: {
  programs.nixvim = {
    plugins.lazy.plugins = with pkgs.vimPlugins; [{
      pkg = base16-nvim;
      lazy = false;
      main = "base16-colorscheme";
      opts = builtins.mapAttrs(_: color: "#" + color) config.colorScheme.palette;
    }];
  };
}
