{lib, ...}: let
  opts = {
    noremap = true;
    silent = true;
  };
  inherit (builtins) elemAt;
  mkMap = mode:
    lib.mapAttrsToList (key: action: {
      inherit key mode;
      action = elemAt action 0;
      options = {
        noremap = true;
        silent = true;
        desc = elemAt (action ++ [null]) 1;
      };
    });
in {
  nmap = mkMap "n";
  imap = mkMap "i";
  vmap = mkMap "v";
}
