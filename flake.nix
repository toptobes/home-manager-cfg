{
  description = "Home Manager configuration of me";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      # localpkgs = import ./packages pkgs;
    in {
      homeConfigurations."me" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        # extraSpecialArgs = { inherit localpkgs; };
      };
    };
}
