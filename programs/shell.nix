{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    httpie
    tree
    tldr
    bat
    trashy
    eza
    jq
  ];

  programs.vim = {
    enable = true;
    defaultEditor = true;  
  };

  programs.starship = {
    enable = true;
    settings = lib.importTOML ./configs/starship.toml;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    autocd = false;
    enableCompletion = true;
    autosuggestion.enable = true;

    syntaxHighlighting = {
      enable = true;
      styles = {
        arg0 = "fg=cyan";
      };
    };

    history = {
      size = 5000;
      expireDuplicatesFirst = true;
      share = false;
    };

    shellAliases = {
      "grep"  = "grep --color=auto";
      "fgrep" = "fgrep --color=auto";
      "egrep" = "egrep --color=auto";

      "ls" = "eza";
      "ll" = "ls -alF";
      "la" = "ls -A";

      "tp" = "trash put";
      "tl" = "trash list";

      "cl" = "precmd() { precmd() { echo } } && clear";

      "bat" = "bat -P";
      ".."  = "cd ..";
      "v"   = "vim";

      "nix-gc" = "nix-collect-garbage -d && nix-store --optimize && nix-collect-garbage -d";
      "nix-shell" = "nix-shell --command zsh";

      "http" = "http --verify no";
    };

    initExtra = ''
      # https://github.com/starship/starship/issues/560#issuecomment-2197994300
      precmd() { precmd() { echo "" } }

      # remove bolding from LS_COLORS while retaining brightness
      eval $(dircolors | sed -E 's/01;3([0-7])/9\1/g')

      # make less more friendly for non-text input files, see lesspipe(1)
      [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

      # zsh-vi-mode keybinding config
      function zvm_after_lazy_keybindings() {
        zvm_bindkey vicmd 'H' beginning-of-line
        zvm_bindkey vicmd 'L' end-of-line
      }

      # https://superuser.com/a/311747
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word

      # ctrl + space to autocomplete
      bindkey '^ ' autosuggest-accept

      # https://github.com/zsh-users/zsh-autosuggestions/issues/265#issuecomment-339235780
      # https://github.com/jeffreytse/zsh-vi-mode?tab=readme-ov-file#execute-extra-commands
      zvm_after_init_commands+=('bindkey ^F vi-forward-word && bindkey ^B vi-backward-word')
    '';

    profileExtra = ''
      # https://discourse.nixos.org/t/using-home-manager-to-control-default-user-shell/8489/3
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi

      # set PATH so it includes user's private bin if it exists
      if [ -d "$HOME/bin" ] ; then
        PATH="$HOME/bin:$PATH"
      fi

      # set PATH so it includes user's private bin if it exists
      if [ -d "$HOME/.local/bin" ] ; then
        PATH="$HOME/.local/bin:$PATH"
      fi
    '';

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    sessionVariables = {
      ZVM_VI_ESCAPE_BINDKEY = "kj";
    };
  };

  programs.bash = {
    enable = false;
    enableCompletion = true;

    historySize = 1000;
    historyFileSize = 50000;

    historyControl = ["ignoreboth"];
    historyIgnore = ["ls" "cd" "exit"];

    shellAliases = {
      "ls"    = "ls --color=auto";
      "grep"  = "grep --color=auto";
      "fgrep" = "fgrep --color=auto";
      "egrep" = "egrep --color=auto";

      "ll" = "ls -alF";
      "la" = "ls -A";
      "l"  = "ls -CF";

      "alert" = "notify-send --urgency=low -i \"$([ $? = 0 ] && echo terminal || echo error)\" \"$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')\"";

      "tp" = "trash put";
      "tl" = "trash list";

      "cl" = "clear";
      ".." = "cd ..";

      "bat" = "bat -P";

      "nix-gc" = "nix-collect-garbage -d && nix-store --optimize";
    };

    profileExtra = ''
      # set PATH so it includes user's private bin if it exists
      if [ -d "$HOME/bin" ] ; then
        PATH="$HOME/bin:$PATH"
      fi

      # set PATH so it includes user's private bin if it exists
      if [ -d "$HOME/.local/bin" ] ; then
        PATH="$HOME/.local/bin:$PATH"
      fi
    '';

    initExtra = ''
      # make less more friendly for non-text input files, see lesspipe(1)
      [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

      # set variable identifying the chroot you work in (used in the prompt below)
      if [ -z "''${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
      fi

      # set a fancy prompt (non-color, unless we know we "want" color)
      case "$TERM" in
        xterm-color|*-256color) color_prompt=yes;;
      esac

      # create the initial prompt
      if [ "$color_prompt" = yes ]; then
        PS1='${"\${debian_chroot:+($debian_chroot)}"}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      else
        PS1='${"\${debian_chroot:+($debian_chroot)}"}\u@\h:\w\$ '
      fi

      # if this is an xterm set the title to user@host:dir
      case "$TERM" in
      xterm*|rxvt*)
        PS1="\[\e]0;''${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
      *)
        ;;
      esac

      # utility functions
      mkcd()
      {
        mkdir -p -- "$1" && cd -P -- "$_" || exit
      }
    '';

    logoutExtra = ''
      # when leaving the console clear the screen to increase privacy
      if [ "$SHLVL" = 1 ]; then
        [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
      fi
    '';
  };
}
