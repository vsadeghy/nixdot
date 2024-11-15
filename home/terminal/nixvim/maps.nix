{lib, ...}: let
  inherit (builtins) elemAt;
  mkMap = mode:
    lib.mapAttrsToList (key: _action: let
      action = _action ++ [null {}];
      opts = elemAt action 2;
    in {
      inherit key mode;
      action = elemAt action 0;
      options = {
        noremap = opts.noremap or true;
        silent = opts.silent or true;
        remap = opts.remap or false;
        desc = elemAt action 1;
      };
    });
in {
  inherit mkMap;
  nmap = mkMap "n";
  imap = mkMap "i";
  vmap = mkMap "v";
}
