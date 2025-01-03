{pkgs, ...}: {
  imports = [
    ./zsh
    ./nixvim
    ./tmux
    ./kitty.nix
    ./wezterm.nix
    ./ghostty.nix
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
      tmux.enableShellIntegration = true;
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "auto";
      git = true;
    };
  };
}
