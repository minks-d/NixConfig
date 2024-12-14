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
			packages = {
				minksdHome = system: import ./minksdHome.nix { inherit inputs globals overlays; };
			};
		};
}
