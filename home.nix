{ config, pkgs, lib, ... }:

let
  username = "me";
  homeDirectory = "/Users/${username}";
in

{
  nixpkgs.config = {
    allowUnfreePredicate = (_: true);
  };

  imports = (map (n: "${./programs}/${n}") (builtins.filter (lib.hasSuffix ".nix") (builtins.attrNames (builtins.readDir ./programs))));

  home = {
    username = username;
    homeDirectory = homeDirectory;
    
    stateVersion = "24.05";

    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = 1;
    };
  };

  programs.home-manager.enable = true;
  #targets.genericLinux.enable = true;
}
