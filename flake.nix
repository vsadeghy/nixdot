{
  description = "vixdot";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # zen-browser = {
    #   url = "github:MarceColl/zen-browser-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: 
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
      inherit system;
      modules = [
        ./nixos
      ];
    };

    homeConfigurations.vss = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home
      ];
    };
  };
}
