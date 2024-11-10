{pkgs, ...}: {
  imports = [
    ./zsh
    ./nixvim
    ./kitty.nix
  ];
  home.packages = with pkgs; [nitch neofetch];
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd cd"];
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "auto";
      git = true;
    };
  };
}
