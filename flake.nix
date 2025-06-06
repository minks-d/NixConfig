{
  description = "Flake configuration for Daniel Minks PC";

  inputs = rec {
    # NixOS official package source, using the nixos-24.05 branch here
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
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
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    overlays = [
      inputs.nur.overlays.default
      inputs.niri.overlays.niri
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
      minksdHome = import ./minksdHome.nix {inherit inputs globals overlays;};
    };
    homeConfigurations = {
      minksdHome = nixosConfigurations.minksdHome.config.home-manager.users.minksd.home;
    };
    packages = {
      minksdHome = system: import ./minksdHome.nix {inherit inputs globals overlays;};
    };
  };
}
