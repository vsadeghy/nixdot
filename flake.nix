{
  description = "vixdot";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }: 
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in
  {
    nixosConfigurations.vix = lib.nixosSystem {
      specialArgs = { inherit inputs system;};
      modules = [
        ./nixos
      ];
    };
  };
}
