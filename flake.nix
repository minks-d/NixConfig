{
  description = "Flake configuration for Daniel Minks PC";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:/nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix2vim = {
      url = "github:gytis-ivaskevicius/nix2vim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/nur";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      overlays = [ 
      inputs.nix2vim.overlay
      inputs.nur.overlay
      ];  
      globals =
        let
          baseName = "minksulivarri.com";
        in
        rec {
          user = "minksd";
          fullName = "Daniel Minks";
          gitName = fullName;
                  };
    in
    rec {
      nixosConfigurations = {
        minksdHome = import ./minksdHome.nix { inherit inputs globals overlays; };
      };

      

      homeConfigurations = {
        minksdHome = nixosConfigurations.minksdHome.config.home-manager.users.minksd.home;
      };
      packages =
        let
          minksdHome = system: import ./minksdHome.nix { inherit inputs globals overlays; };
          neovim =
            system:
            let
              pkgs = import nixpkgs { inherit system; };
            in
            import ./modules/common/neovim/package { inherit pkgs; };
        in
        {
          x86_64-linux.neovim = neovim "x86_64-linux";
        };

      devShells =
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              nixfmt-rfc-style
              shfmt
              shellcheck
            ];
          };
        };
      formatter = {
        x86_64-linux =

          let
            pkgs = import nixpkgs { inherit system; };
          in

          pkgs.nixfmt-rfc-style;

      };

    };
}
