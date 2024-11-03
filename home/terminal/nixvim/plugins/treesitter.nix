{pkgs, ...}: let
  ensure_installed = [
    "javascript"
    "typescript"
    "jsdoc"
    "json"
    "json5"
    "jsonc"
    "html"
    "css"
    "tsx"
    "nix"
    "markdown"
    "lua"
    "bash"
    "gitignore"
    "python"
    "clojure"
  ];
in {
  home.packages = with pkgs; [gcc tree-sitter volta];
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixGrammars = false;
      settings = {
        inherit ensure_installed;
        auto_install = false;
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = true;
        };
        indent.enable = true;
      };
    };
    lazy.plugins = with pkgs.vimPlugins; [nvim-treesitter hmts-nvim];
  };
}
