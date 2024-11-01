{pkgs, ...}: {
  programs.nixvim.plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = gitsigns-nvim;
      opts = let
        signs = {
          add.text = "+";
          change.text = "~";
          topdelete.text = "‾";
          delete.text = "_";
          changedelete.text = "~";
        };
      in {
        inherit signs;
        signs_staged = signs;
      };
    }
  ];
}
