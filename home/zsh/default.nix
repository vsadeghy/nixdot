{ pkgs, ...} : {
  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      defaultKeymap = "viins";
    
      envExtra = ''
        source $XDG_STATE_HOME/nix/profile/etc/profile.d/hm-session-vars.sh
        [ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
      '';
      initExtraFirst = ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';
      initExtra = ''
        bindkey "^p" history-search-backward
        bindkey "^n" history-search-forward
        compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION
        zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


        clear
        nitch
      '';
    
      history = {
        path = "$XDG_STATE_HOME/history";
        size = 5000;
        save = 5000;
        expireDuplicatesFirst = true;
        append = true;
        share = true;
        ignoreSpace = true;
        ignoreAllDups = true;
        ignoreDups = true;
      };
      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
        }
        {
          name = "powerlevel10k-config";
          src = ./p10k;
          file = "pure.zsh"; # or use lean.zsh for a more complete(bloated) prompt
        }
        {
          name = "powerlevel10k";
          src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
          file = "powerlevel10k.zsh-theme";
        }
      ];
    };
    zoxide = {
     enable = true;
     enableZshIntegration = true;
     options = [ "--cmd cd" ];
    };
    fzf = {
     enable = true;
     enableZshIntegration = true;
    };
  };
}
