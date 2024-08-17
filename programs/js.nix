{ pkgs, ... }:

{
  home.packages = [
    pkgs.nodejs_20
  ];

  programs.bun = {
    enable = true;

    settings = {
      telemetry = false;
    };
  };
}
