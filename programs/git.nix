{ pkgs, ... }:

{
  home.packages = [
    pkgs.gh
  ];

  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "https";
    };

    extensions = with pkgs; [
      gh-poi
      gh-markdown-preview
    ];
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = "toptobes";
    userEmail = "kavinpg@gmail.com";

    aliases = {
      oops = "!git commit -a --amend --no-edit";
      yolo = "!git commit -am \"$(curl -s https://whatthecommit.com/index.txt)\"";
      lg   = "!git log --graph --pretty=format:'%Cred%h %Cblue%an%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
    };

    difftastic = {
      enable = true;
    };

    extraConfig = {
      color.ui = "auto";
    };
  };
}
