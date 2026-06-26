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

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
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
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
    oisd = {
      url = "github:cbuijs/oisd";
      flake = false;
    };
    wallpapers = {
      url = "github:OrbEnforcer/Nihon-Walls";
      flake = false;
    };
    local-packages = {
      url = "git+file:./?dir=packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      lix-module,
      nur,
      niri,
      fenix,
      nix-minecraft,
      home-manager,
      rust-overlay,
      sops-nix,
      agenix,
      local-packages,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      overlays = [
        nur.overlays.default
        niri.overlays.niri
        rust-overlay.overlays.default
        fenix.overlays.default
        nix-minecraft.overlay
        (_: prev: {
          openldap = prev.openldap.overrideAttrs {
            doCheck = builtins.trace "Check if removing this overlay is viable. From: ./flake.nix" (!prev.stdenv.hostPlatform.isi686);
          };
        })
      ];
      imports = [
        nix-minecraft.nixosModules.minecraft-servers
        home-manager.nixosModules.home-manager
        niri.nixosModules.niri
        nix-minecraft.nixosModules.minecraft-servers
        sops-nix.nixosModules.sops
        agenix.nixosModules.default
      ];
      globals =
        let
          baseName = "minksulivarri.com";
        in
        rec {
          secretsDir = ./modules/common/secrets;
          packagesDir = ./packages;
          user = "minksd";
          fullName = "Daniel Minks";
          gitName = fullName;
          inherit self;
        };
    in
    rec {
      nixosConfigurations = {
        minksdHome = import ./minksdHome {
          inherit
            system
            inputs
            globals
            overlays
            imports
            ;
        };
        minksdLaptop = import ./minksdLaptop {
          inherit
            system
            inputs
            globals
            overlays
            imports
            ;
        };
        minksdWSL = import ./minksdWSL {
          inherit
            system
            inputs
            globals
            overlays
            imports
            ;
        };
      };
      homeConfigurations = {
        minksdHome = nixosConfigurations.minksdHome.config.home-manager.users.minksd.home;
        minksdWSL = nixosConfigurations.minksdWSL.config.home-manager.users.minksd.home;
        minksdLaptop = nixosConfigurations.minksdLaptop.config.home-manager.users.minksd.home;
      };
      packages = {
        minksdHome =
          system:
          import ./minksdHome {
            inherit
              system
              inputs
              globals
              overlays
              ;
          };
        minksdWSL =
          system:
          import ./minksdWSL {
            inherit
              system
              inputs
              globals
              overlays
              ;
          };
        minksdLaptop =
          system:
          import ./minksdLaptop {
            inherit
              system
              inputs
              globals
              overlays
              ;
          };

      };
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
