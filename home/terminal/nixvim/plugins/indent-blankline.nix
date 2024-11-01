{pkgs, ...}: {
  programs.nixvim.plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = indent-blankline-nvim;
      main = "ibl";
      opts = {
        indent.char = "▏";
        scope = {
          show_start = false;
          show_end = false;
          show_exact_scope = false;
        };
        exclude = {
          filetypes = [
            "help"
            "startify"
            "dashboard"
            "neogitstatus"
            "NvinTree"
            "Trouble"
          ];
        };
      };
    }
  ];
}
