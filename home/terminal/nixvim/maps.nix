{ lib, ... }: let
  opts = { noremap = true; silent = true; };
  inherit (builtins) elemAt;
  mkMap = mode: lib.mapAttrsToList ( key: action: {
    inherit key mode;
    action = elemAt action 0;
    options = opts // elemAt (action++[{}]) 1;
  });
in rec {
  nmap = mkMap "n";
  imap = mkMap "i";
  vmap = mkMap "v";
}
