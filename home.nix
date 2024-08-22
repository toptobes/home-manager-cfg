{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = (_: true);
  
  imports = map (n: "${./programs}/${n}") (builtins.filter (lib.hasSuffix ".nix") (builtins.attrNames (builtins.readDir ./programs)));

  home = {
    username = "me";
    homeDirectory = "/home/me";
    
    stateVersion = "24.05";

    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
    };
  };

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
}
