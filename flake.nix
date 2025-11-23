{
  description = "Flake configuration for Daniel Minks PC";
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:/nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:/sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    fenix = {
      url = "github:/nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };
outputs = {nixpkgs, ...} @ inputs: let
  system = "x86_64-linux";
  overlays = [
    inputs.nur.overlays.default
    inputs.niri.overlays.niri
    inputs.fenix.overlays.default
    inputs.nix-minecraft.overlay
  ];
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];
  globals = let
    baseName = "minksulivarri.com";
  in rec {
    user = "minksd";
    fullName = "Daniel Minks";
    gitName = fullName;
  };
in rec {
  nixosConfigurations = {
    minksdHome = import ./minksdHome.nix {inherit inputs globals overlays imports;};
  };
  homeConfigurations = {
    minksdHome = nixosConfigurations.minksdHome.config.home-manager.users.minksd.home;
  };
  packages = {
    minksdHome = system: import ./minksdHome.nix {inherit inputs globals overlays;};
  };
};
}
