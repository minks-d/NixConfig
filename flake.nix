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
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:/nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    niri = {
      url = "github:/sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    fenix = {
      url = "github:/nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    oisd = {
      url = "https://big.oisd.nl/domainswild";
      flake = false;
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs = inputs:
    let
      inherit (inputs)
        nur
        niri
        fenix
        nix-minecraft
        home-manager
        rust-overlay;
      
      system = "x86_64-linux";
      overlays = [
        nur.overlays.default
        niri.overlays.niri
        fenix.overlays.default
        rust-overlay.overlays.default
        nix-minecraft.overlay
      ];
      imports = [
        nix-minecraft.nixosModules.minecraft-servers
        home-manager.nixosModules.home-manager
        niri.nixosModules.niri
        nix-minecraft.nixosModules.minecraft-servers
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
        minksdHome = import ./minksdHome {inherit system inputs globals overlays imports;};
        minksdWSL = import ./minksdWSL {inherit system inputs globals overlays imports;};
      };
      homeConfigurations = {
        minksdHome = nixosConfigurations.minksdHome.config.home-manager.users.minksd.home;
        minksdWSL = nixosConfigurations.minksdWSL.config.home-manager.users.minksd.home;
      };
      packages = {
        minksdHome = system: import ./minksdHome {inherit system inputs globals overlays;};
        minksdWSL = system: import ./minksdWSL {inherit system inputs globals overlays;};

      };
    };
}
