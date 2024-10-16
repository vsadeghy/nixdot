# {
#   description = "vixdot";
# 
#   inputs = {
#     nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
#     home-manager = {
#       url = "github:nix-community/home-manager";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#   };
# 
#   outputs = { self, nixpkgs, ... }@inputs: 
#   let
#     system = "x86_64-linux";
#     pkgs = import nixpkgs {
#       inherit system;
#       config = {
#         allowUnfree = true;
#       };
#     };
#   in
#   {
#     nixosConfigurations = {
#       specialArgs = { inherit inputs system;};
#       modules = [
#         ./nixos
#         ./nixos/modules
#       ];
#     };
#   };
# }


{
  description = "vixdot";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./nixos
      ];

      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, ... }: {
        devShells.python = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ neovim python ];
        };
        formatter = pkgs.nixfmt-rfc-style;
      };
    };

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
