{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    awscli2
    azure-cli
    google-cloud-sdk
  ];
}
